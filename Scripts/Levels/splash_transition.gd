extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func play_click():
	AudioManager.play_sound(AudioManager.SPLASH_CLICK)

func play_glitch():
	AudioManager.play_sound(AudioManager.SPLASH_GLITCH)

func switch_to_menu():
	get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")
