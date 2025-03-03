extends Node2D
var full = false

func _ready() -> void:
	_process(1)

var inc = 0
var pos = 20
var level_num = 0

func _input(button):
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _process(delta: float) -> void:
	while pos > 0:
		inc += 1
		if inc % 60 == 0:
			pos -= 1
			#print([delta, inc, pos])


func level_up(lvl, lines=0):
	while lines < 640:
		lines += 1
		#print(lines)
		if lines >= lvl * 10 and lvl < 50:
			lvl += 1
			#print("Level up: " + str(lvl))


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Pregame.tscn")


func _on_experi_mode_pressed() -> void:
	var confirm = $ExperiMode/PlayExpMode
	confirm.popup_centered()
	confirm.show()


func _on_play_exp_mode_confirmed() -> void:
	get_tree().change_scene_to_file("res://exp_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings.tscn")
