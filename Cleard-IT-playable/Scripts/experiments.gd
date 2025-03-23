extends Node2D

var full = false
var process_input = true
#@onready var stats = $Stats


func _input(_a):
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func display_score():
	var score = $i_polyblock.fetch_score()
	var high = 0
	if score > high:
		high = score
	#stats.text = "Score: " + str(score) + "High Score: " + str(high)
	print(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause()


func pause():
	var menu = $Pause
	menu.popup_centered()
	menu.show()
	get_tree().paused = true


func _on_pause_canceled() -> void:
	get_tree().paused = false


func _on_pause_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes//exp_menu.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//Menu0.tscn")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//EXPmode.tscn")


func _on_customize_pressed() -> void:
	var confirm = $Customize/Advanced
	confirm.popup_centered()
	confirm.show()


func _on_advanced_confirmed() -> void:
	get_tree().change_scene_to_file("res://scenes//customizations.tscn")


func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//exp_menu.tscn")
