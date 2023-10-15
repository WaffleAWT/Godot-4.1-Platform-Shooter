extends GPUParticles2D

#Refrences
@onready var secondary_particle : GPUParticles2D = $GPUParticles2D

func _ready():
	emitting = true
	secondary_particle.emitting = true

func _on_timer_timeout():
	queue_free()
