extends Node2D

var full = false
var process_input = true
#@onready var stats = $Stats


func _input(a):
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	get_tree().change_scene_to_file("res://exp_menu.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu0.tscn")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://EXPmode.tscn")
