extends Node
var full = false
var tutorial = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(a):
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu0.tscn")


func _on_tutorial_pressed() -> void:
	var confirm = $Tutorial/PlayTutorMode
	confirm.popup_centered()
	confirm.show()


func _on_play_tutor_mode_confirmed() -> void:
	tutorial = true
