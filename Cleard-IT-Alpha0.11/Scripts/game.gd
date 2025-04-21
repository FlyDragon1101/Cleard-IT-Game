extends Node
var full = false
var tutorial = false


var settings_file = "res://Saves//settings.dat"


var player_name: String
var score: int
var total_lines_cleared: int
var level: int
var high_score: int
var time: int
var score_log: String


func _ready() -> void:
	load_data()


func _input(_a):
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func save_info():
	var file = FileAccess.open(settings_file, FileAccess.WRITE)
	file.store_line(player_name)
	file.store_32(score)
	file.store_8(level)
	file.store_float(time)
	file.store_line(score_log)
	file.close()


func load_data():
	var file = FileAccess.open(settings_file, FileAccess.READ)
	# Order matters. The same order you use to write, is the order you use to read
	player_name= file.get_line()
	score = file.get_32()
	level = file.get_8()
	time = file.get_32()
	score_log = file.get_line()
	file.close()


func _on_button_pressed() -> void:
	save_info()
	print(player_name)
	#if player_name != "":
	get_tree().change_scene_to_file("res://scenes//main_game.tscn")
	#else:
		#$Button/AcceptDialog.popup_centered()
		#$Button/AcceptDialog.dialog_text += player_name


func _on_back_pressed() -> void:
	save_info()
	get_tree().change_scene_to_file("res://scenes//Menu0.tscn")


func _on_tutorial_pressed() -> void:
	var confirm = $Tutorial/PlayTutorMode
	confirm.popup_centered()
	confirm.show()


func _on_play_tutor_mode_confirmed() -> void:
	save_info()
	tutorial = true
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")


func _on_username_text_submitted(new_text: String) -> void:
	save_info()
	player_name = new_text
	print(player_name)


func _on_level_value_changed(value: float) -> void:
	save_info()
	level = int(value)
	print(level)
