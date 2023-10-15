extends Control

#Refrences
@onready var bullet_counter : Label = $Slot/Label

func _ready():
	EventManager.update_bullet_ui.connect(update_bullet_counter)

func update_bullet_counter():
	bullet_counter.text = "x" + str(EventManager.bullets_amount)
