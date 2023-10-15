extends Area2D

#Data
var player = null

func can_see_player():
	return player != null

func _on_body_entered(body):
	player = body

func _on_body_exited(_body):
	player = null
