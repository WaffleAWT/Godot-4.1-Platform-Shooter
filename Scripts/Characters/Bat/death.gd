extends State

#Refrences
@export var black_death_particle : GPUParticles2D
@onready var timer : Timer = $Timer

func enter(_msg := {}):
	owner.emote.visible = false
	owner.collision.disabled = true
	owner.animator.visible = false
	black_death_particle.emitting = true
	timer.start()
	AudioManager.play_sound(AudioManager.DEATH)

func _on_timer_timeout():
	owner.queue_free()
