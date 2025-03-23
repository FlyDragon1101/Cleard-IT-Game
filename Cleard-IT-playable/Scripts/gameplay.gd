extends Node2D

#const polyblocks = "res://scenes//polyblocks.tscn"

var full = false
var p = false

@onready var playfield: TileMapLayer = $Playfield

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#start()


func _input(button):
	#if game_over():
	if button.is_action_pressed("ui_select"):
		get_tree().change_scene_to_file("res://scenes//post_game.tscn")
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

var inc = 0
var pos = 20
var level_num = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	inc += 1
	if inc % frame_table[level_num] == 0 and pos > 0:
		pos -= 1
		print([delta, inc, pos])
	if Input.is_action_just_pressed("Pause"):
		pause()


func full_lines(polyblock):
	var verts = []
	for b in polyblock:
		var share_lines = []
		for pc in $I_polyblock.get_children():
			if abs(pc.global_position.y - b.global_position.y) < 10:
				share_lines.append(pc)
		if len(share_lines) >= 1:
			verts.append(share_lines[0].global_position.y)
			for i in share_lines:
				i.queue_free()
	fall_down(verts)


func fall_down(y_lines):
	for pb in $I_polyblock.get_children():
		var n = 0
		for line in y_lines:
			if pb.global_position.y > 1:
				n += 1
		pb.fall(n)


const clears = {0: 0, 1: 100, 2: 250, 3: 600, 4: 1200}
const line_clears = [0, 1, 2, 3, 4]
const bonus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2]
const frame_table = [60, 50, 45, 40, 36, 30, 27, 24, 20, 18, 15, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1]
const fall_distance = [2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 8, 10, 20]
const lock_delay = 20


func line_clear():
	const lines_cleared = ["single", "double", "triple", "QUAD"]


func score_log():
	var logs = $ScoreLog


func pause():
	var menu = $Pause
	menu.popup_centered() # center on screen
	menu.show()
	get_tree().paused = true


func level_up(lvl, lines=0):
	if line_clear():
		lines += 1
		print(lines)
		if lines >= lvl * 10 and lvl < 50:
			lvl += 1
			print("Level up: " + str(lvl))


func scoring(line_cleared, level, points=0, lines=0):
	var earnings = 0
	var r = randi_range(0, len(line_clears)-1)
	var b = randi_range(0, len(bonus)-1)
	lines += r
	if lines >= level * 10 and level < 50:
		level += 1
	
	if bonus[b] == 1 and r != 0:
		print("Piece spin!")
		earnings = 3 * (level * clears[line_cleared[r]])
	elif bonus[b] == 2 and r != 0:
		print("ALL CLEAR!")
		earnings = 8 * (level * clears[line_cleared[r]])
	else:
		earnings = (level * clears[line_cleared[r]])
	
	points += earnings
	if r != 0:
		print([level, lines, earnings, points])
	print("Congratulations! You Cleared it (beat the game)!")


func _on_panel_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause") and not p:
		p = true
		show()
	elif Input.is_action_just_pressed("Pause") and p:
		p = false
		hide()


func _on_pause_canceled() -> void:
	get_tree().paused = false


func _on_pause_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes//Pregame.tscn")


func game_over():
	return $I_polyblock.position == $"GameOver".position
	#_on_game_over_gui_input()


func _on_game_over_gui_input(_event: InputEvent) -> void:
	if position.y < 120:
		get_node("Game Over")
