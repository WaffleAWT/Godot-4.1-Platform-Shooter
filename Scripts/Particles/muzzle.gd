extends GPUParticles2D

func _ready():
	emitting = true

func _on_timer_timeout():
	queue_free()
