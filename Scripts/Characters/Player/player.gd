extends CharacterBody2D

#Data
var bullets_amount : int = 30

@export var movement_data : MovementData
@export var stats : Stats

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var guns_animator : AnimationPlayer = $ShootingAnimationPlayer
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var hand : Node2D = $Hand
@onready var pistol : Sprite2D = $Hand/Pivot/Pistol
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker

@export var camera : Camera2D

#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://Scenes/Particles/muzzle.tscn")
@onready var bullet_load : PackedScene = preload("res://Scenes/Props/bullet.tscn")
@onready var death_particle_load : PackedScene = preload("res://Scenes/Particles/player_death_particle.tscn")

func _ready():
	stats.health = stats.max_health
	EventManager.bullets_amount = bullets_amount
	EventManager.update_bullet_ui.emit()

func _physics_process(delta):
	apply_gravity(delta)
	
	var input_vector = Input.get_axis("move_left","move_right")
	if input_vector != 0:
		apply_acceleration(input_vector, delta)
	else:
		apply_friction(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	if Input.is_action_just_pressed("shoot"):
		if bullets_amount > 0:
			guns_animator.play("Shoot")
	
	move_and_slide()
	animate(input_vector)

func apply_acceleration(input_vector, delta):
	velocity.x = move_toward(velocity.x, movement_data.max_speed * input_vector, movement_data.acceleration * delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += movement_data.gravity * movement_data.gravity_scale * delta

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func jump():
	velocity.y = -movement_data.jump_strength
	AudioManager.play_sound(AudioManager.JUMP)

func shoot():
	bullets_amount -= 1
	EventManager.bullets_amount -= 1
	EventManager.update_bullet_ui.emit()
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	var muzzle = muzzle_load.instantiate()
	var bullet = bullet_load.instantiate()
	pistol_bullet_marker.add_child(muzzle)
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector = mouse_position
	bullet.rotation = mouse_position.angle()
	get_tree().current_scene.add_child(bullet)
	AudioManager.play_sound(AudioManager.SHOOT)

func small_shake():
	camera.small_shake()

func animate(input_vector):
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_position.x > 0 and animator.flip_h:
		animator.flip_h = false
	elif mouse_position.x < 0 and not animator.flip_h:
		animator.flip_h = true
	
	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("Run")
		else:
			animator.play("Idle")
	else:
		if velocity.y > 0:
				animator.play("Fall")
		else:
				animator.play("Jump")

func _on_hurtbox_area_entered(_area):
	hit_animator.play("Hit")
	EventManager.update_health_ui.emit()
	if stats.health <= 0:
		die()
	else:
		AudioManager.play_sound(AudioManager.HURT)
		EventManager.frame_freeze.emit()

func die():
	AudioManager.play_sound(AudioManager.DEATH)
	var death_particle = death_particle_load.instantiate()
	death_particle.global_position = global_position
	get_tree().current_scene.add_child(death_particle)
	EventManager.player_died.emit()
	queue_free()
