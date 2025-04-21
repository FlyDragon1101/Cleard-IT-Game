extends Node2D
var full = false


func _ready() -> void:
	pass


func _input(button):
	if button.is_action_pressed("ui_select"):
		get_tree().change_scene_to_file("res://scenes//Menu0.tscn")
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
