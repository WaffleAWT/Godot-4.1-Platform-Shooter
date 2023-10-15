extends Node2D

#Data
const MOUSE : CompressedTexture2D = preload("res://Textures/UI/Mouse.png")
const MOUSE_OFFSET : Vector2 = Vector2(0, 0)

#Refrences
@onready var main_menu_button : Button = $UI/MainMenu
@onready var chromatic_abberation : ColorRect = $UI/ChromaticAbberation

func _ready():
	EventManager.player_died.connect(player_died)
	EventManager.frame_freeze.connect(frame_freeze)

func player_died():
	main_menu_button.visible = true
	DisplayServer.cursor_set_custom_image(MOUSE, DisplayServer.CURSOR_ARROW, MOUSE_OFFSET)

func _on_main_menu_button_up():
	AudioManager.play_sound(AudioManager.MENU_CLICK)
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")

func _on_main_menu_mouse_entered():
	AudioManager.play_sound(AudioManager.MENU_HOVER)

func _on_border_body_entered(body):
	body.die()

func frame_freeze():
	var time_scale_value : float = 0.1
	var duration : float = 0.4
	Engine.time_scale = time_scale_value
	chromatic_abberation.visible = true
	await get_tree().create_timer(duration * time_scale_value).timeout
	Engine.time_scale = 1.0
	chromatic_abberation.visible = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
