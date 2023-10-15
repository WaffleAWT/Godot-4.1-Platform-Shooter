extends CharacterBody2D

#Data
@export var movement_data : MovementData
@export var stats : Stats

#Refrences
@onready var start_position : Vector2 = global_position
@onready var target_position : Vector2 = global_position
@onready var player_detection_zone : Area2D = $PlayerDetectionZone
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox : Area2D = $Hitbox
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var emote : Sprite2D = $Emote
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var state_machine : StateMachine = $StateMachine
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var health_bar_timer : Timer = $HealthBar/HealthBarTimer

func _ready():
	stats.health = stats.max_health

func _physics_process(_delta):
	hitbox.knockback_vector = velocity.normalized() #Updating the knockback vector
	move_and_slide()

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func _on_hurtbox_area_entered(area):
	if not area.is_in_group("Bat"):
		knockback(area.knockback_vector)
		hit_animator.play("Hit")
		update_health_bar()
		if stats.health <= 0:
			state_machine.call_deferred("transition_to", "Death")
			health_bar.visible = false

func update_health_bar():
	health_bar.value = stats.health
	health_bar.visible = true
	health_bar_timer.start()

func _on_health_bar_timer_timeout():
	health_bar.visible = false
