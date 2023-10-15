extends Control

#Refrences
@onready var bar : TextureProgressBar = $TextureProgressBar

func _ready():
	EventManager.update_health_ui.connect(decrement_health)

func decrement_health():
	bar.value -= 1
