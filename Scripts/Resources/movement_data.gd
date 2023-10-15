extends Resource
class_name MovementData

#Data
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var max_speed : int
@export var acceleration : int
@export var friction : int
@export var gravity_scale : float
@export var jump_strength : int
@export var knockback_force : int
