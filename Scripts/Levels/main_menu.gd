extends Control

#Data
const CROSSHAIR : CompressedTexture2D = preload("res://Textures/UI/Crosshair.png")
const MOUSE : CompressedTexture2D = preload("res://Textures/UI/Mouse.png")
const CROSSHAIR_OFFSET : Vector2 = Vector2(12, 12)
const MOUSE_OFFSET : Vector2 = Vector2(0, 0)

#Refrences
@onready var head : Sprite2D = $Head

func _ready():
	DisplayServer.cursor_set_custom_image(MOUSE, DisplayServer.CURSOR_ARROW, MOUSE_OFFSET)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	var mouse_position : Vector2 = get_global_mouse_position()
	if mouse_position.x > head.position.x:
		head.flip_h = false
	else:
		head.flip_h = true

func _on_start_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_quit_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_start_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	DisplayServer.cursor_set_custom_image(CROSSHAIR, DisplayServer.CURSOR_ARROW, CROSSHAIR_OFFSET)
	get_tree().change_scene_to_file("res://Scenes/Levels/prototype.tscn")

func _on_quit_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().quit()
