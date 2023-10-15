extends Camera2D

#Data
var decay : float = 0.8
var max_offset = Vector2(100, 75)
var max_roll : float = 0.1

var trauma : float = 0.0
var trauma_power : int = 2

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func small_shake():
	add_trauma(0.2)
