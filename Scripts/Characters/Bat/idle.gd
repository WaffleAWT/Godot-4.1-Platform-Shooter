extends State

#Data
var target_range : int = 4

#Refrences
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	start_timer()

func physics_update(delta):
	seek_player()
	
	if owner.global_position.distance_to(owner.start_position) <= target_range:
		apply_friction(delta)
	else:
		accelerate_towards_point(owner.start_position, delta)

func apply_friction(delta):
	owner.velocity = owner.velocity.move_toward(Vector2.ZERO, owner.movement_data.friction * delta)

func accelerate_towards_point(point, delta):
	#Moving to the start position
	var direction = owner.global_position.direction_to(point).normalized()
	owner.velocity = owner.velocity.move_toward(direction * owner.movement_data.max_speed, owner.movement_data.acceleration * delta)
	
	#Look where moving
	owner.animator.flip_h = owner.velocity.x > 0

func seek_player(): #Looks for player
	if owner.player_detection_zone.can_see_player():
		state_machine.transition_to("Attack")

func start_timer():
	timer.wait_time = randi_range(1, 5)
	timer.start()

func _on_timer_timeout(): #Picks a random state
	var random_number : int = randi_range(1, 2)
	if random_number == 1:
		state_machine.transition_to("Wander")
	else:
		start_timer()
