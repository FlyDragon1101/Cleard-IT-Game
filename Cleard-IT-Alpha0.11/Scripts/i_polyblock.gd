extends Node2D

@export var score = 0
@onready var locked = $LockedPieces
@onready var active_pieces = $Pieces

var i_polyblock =  [[Vector2i(-2, -1), Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1)],
					[Vector2i(0, -2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1)],
					[Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
					[Vector2i(-1, -2), Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1)]]

var j_polyblock =  [[Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)], 
					[Vector2i(0, -1), Vector2i(1, -1), Vector2i(0, 0), Vector2i(0, 1)],
					[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1)],
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(-1, 1), Vector2i(0, 1)]]

var l_polyblock =  [[Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1)],
					[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 1)],
					[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1)]]

var o_polyblock =  [[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)],
					[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)],
					[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)], 
					[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)]]

var s_polyblock =  [[Vector2i(0, -1), Vector2i(1, -1), Vector2i(-1, 0), Vector2i(0, 0)],
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1)],
					[Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 1), Vector2i(0, 1)],
					[Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(0, 1)]]

var t_polyblock =  [[Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)], 
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)],
					[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)],
					[Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(0, 1)]]

var z_polyblock =  [[Vector2i(-2, -1), Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0)],
					[Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0), Vector2i(-1, 1)],
					[Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, 1)],
					[Vector2i(-1, -1), Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(-2, 1)]]

var tri_polyblock =[[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)],
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1)],
					[Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)], 
					[Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1)]]

var triv_polyblock=[[Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, -1)],
					[Vector2i(-1, -1), Vector2i(0, -1), Vector2i(0, 0)],
					[Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)], 
					[Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(0, 0)]]

var duo_polyblock =[[Vector2i(-1, -1), Vector2i(0, -1)],
					[Vector2i(0, -1), Vector2i(0, 0)],
					[Vector2i(-1, 0), Vector2i(0, 0)],
					[Vector2i(-1, -1), Vector2i(-1, 0)]]

const frame_table = [60, 50, 45, 40, 36, 30, 27, 24, 20, 18, 15, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1]
const fall_distance = [1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 9, 20]
const clears = {0: 0, 1: 100, 2: 250, 3: 600, 4: 1200}
const line_clears = [0, 1, 2, 3, 4]
const lc = ["", "single", "double", "triple", "QUAD!"]
var pieces = [i_polyblock, j_polyblock, l_polyblock, o_polyblock, s_polyblock, t_polyblock, z_polyblock, tri_polyblock, triv_polyblock, duo_polyblock]

const width = 10
const height = 24
const block_size = 40
const start_pos = Vector2i(5, 4)
var position_now: Vector2i

var level = 1
var lock_delay = 20
var presses = 16
var press_left = 4
var press_right = 4

var DAS = 3
var inc = 0
var total_lines_cleared = 0

var empty = true
var running = true
var leveled_up = false

var get_spin_bonus = false
var held = false
var flipped = false
var full = false
var p = false

var current_piece = []
var next_piece1 = []
var next_piece2 = []
var next_piece3 = []

var next_lineup = []
var hold_lineup = []
var active_piece = []
var rotator = 0
var travel = 0

const tileID = 1
var color_map: Vector2i
var next_color_map1: Vector2i
var next_color_map2: Vector2i
var next_color_map3: Vector2i
var hold_color_map: Vector2i


func jlstz_srs():
	return {
		"cw01": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0,-2), Vector2i(-1,-2)],
		"ccw2": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1,-1), Vector2i(0, 2), Vector2i(1, 2)],
		"cw02": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1,-1), Vector2i(0, 2), Vector2i(1, 2)],
		"ccw3": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0,-2), Vector2i(-1,-2)],
		"cw03": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0,-2), Vector2i(1,-2)],
		"ccw4": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1,-1), Vector2i(0, 2), Vector2i(-1, 2)],
		"cw04": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-1,-1), Vector2i(0, 2), Vector2i(-1, 2)],
		"ccw1": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0,-2), Vector2i(1,-2)],
	}


func i_srs():
	return {
		"cw01": [Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), Vector2i(-2,-1), Vector2i(1, 2)],
		"ccw2": [Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(2, 1), Vector2i(-1,-2)],
		"cw02": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-1, 2), Vector2i(2,-1)],
		"ccw3": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), Vector2i(1,-2), Vector2i(-2, 1)],
		"cw03": [Vector2i(0, 0), Vector2i(2, 0), Vector2i(-1, 0), Vector2i(2, 1), Vector2i(-1,-2)],
		"ccw4": [Vector2i(0, 0), Vector2i(-2, 0), Vector2i(1, 0), Vector2i(-2,-1), Vector2i(1, 2)],
		"cw04": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-2, 0), Vector2i(1,-2), Vector2i(-2, 1)],
		"ccw1": [Vector2i(0, 0), Vector2i(-1, 0), Vector2i(2, 0), Vector2i(-1, 2), Vector2i(2,-1)],
	}


func _ready():
	play()


func draw(piece, pos_now, map):
	for block in piece:
		active_pieces.set_cell(pos_now + block, tileID, map)


func block_init():
	position_now = start_pos
	active_piece = current_piece[rotator]
	draw(active_piece, position_now, color_map)
	
	draw(next_piece1[rotator], Vector2i(15, 6), next_color_map1)
	draw(next_piece2[rotator], Vector2i(15, 11), next_color_map2)
	draw(next_piece3[rotator], Vector2i(15, 16), next_color_map3)


func get_piece():
	var selected = pieces[randi_range(0, len(pieces)-1)]
	return selected


func play():
	score = 0
	$"Panel2".visible = false
	running = true
	
	current_piece = get_piece()
	color_map = Vector2i(pieces.find(current_piece), 0)
	
	next_piece1 = get_piece()
	next_color_map1 = Vector2i(pieces.find(next_piece1), 0)
	
	next_piece2 = get_piece()
	next_color_map2 = Vector2i(pieces.find(next_piece2), 0)
	
	next_piece3 = get_piece()
	next_color_map3 = Vector2i(pieces.find(next_piece3), 0)
	
	block_init()


#func can_rotate(direction):
	#var new_angle = (rotator + direction) % 4
	#var new_rotation = current_piece[new_angle]
	#
	#for block in new_rotation:
		#if not in_matrix_x(position_now + block) or not in_matrix_y(position_now + block):
			#return false
	#return true


func rotate_piece(deg=0, direction="", moved=false):
	const rotations = [["cw01", "ccw1"], ["cw02", "ccw2"], ["cw03", "ccw3"], ["cw04", "ccw4"]]
	
	var srs1 = jlstz_srs()
	var srs2 = i_srs()
	var position_new = position_now
	
	if Input.is_action_just_pressed("Rotate Clockwise") and press_right > 0:
		direction = rotations[rotator][0]
		deg = 1
		if current_piece == tri_polyblock or current_piece == triv_polyblock or current_piece == duo_polyblock:
			press_right -= 1
	elif Input.is_action_just_pressed("Rotate Conterclockwise") and press_left > 0:
		direction = rotations[rotator][-1]
		deg = -1
		if current_piece == tri_polyblock or current_piece == triv_polyblock or current_piece == duo_polyblock:
			press_left -= 1
	
	#if can_rotate(deg):
	change_tiles()
	rotator = (rotator + deg) % 4
	active_piece = current_piece[rotator]
	
	if current_piece == i_polyblock:
		for block in active_piece:
			if not in_matrix_x(position_now + block) or not in_matrix_y(position_now + block):
				for move in srs2[direction]:
					#print([position_now + block + move, active_piece, srs2[direction]])
					if in_matrix_x(position_now + block + move) and in_matrix_y(position_now + block + move):
						position_new = position_now + move
						moved = true
						break
					else:
						position_new = position_now
						moved = false
		if moved:
				print([position_now, position_new])
				position_now = position_new
				#break
	
	if current_piece == j_polyblock or current_piece == l_polyblock or current_piece == s_polyblock or current_piece == t_polyblock or current_piece == z_polyblock:
		for block in active_piece:
			if not in_matrix_x(position_now + block) or not in_matrix_y(position_now + block):
				for move in srs1[direction]:
					#print([position_now + block + move, rotator, srs1[direction]])
					if in_matrix_x(position_now + block + move) and in_matrix_y(position_now + block + move):
						position_new = position_now + move
						moved = true
						break
					else:
						position_new = position_now
						moved = false
			if moved:
				print([position_now, position_new])
				position_now = position_new
				#break
	
	draw(active_piece, position_now, color_map)


func change_tiles():
	for block in active_piece:
		active_pieces.erase_cell(position_now + block)


func move_contol(motion):
	if not_colliding_x(motion) and not_colliding_y(motion):
		change_tiles()
		position_now += motion
		draw(active_piece, position_now, color_map)
	
	else:
		if motion == Vector2i.DOWN and lock_delay == 0:
			land()
			clear_line()
			new_piece()
			
			dequeue_lineup()
			block_init()
			
			topout(position_now.x, position_now.y)
			held = false


func new_piece():
	lock_delay = 20
	current_piece = next_piece1
	color_map = next_color_map1
	
	next_piece1 = next_piece2
	next_color_map1 = next_color_map2
	
	next_piece2 = next_piece3
	next_color_map2 = next_color_map3
	
	next_piece3 = get_piece()
	next_color_map3 = Vector2i(pieces.find(next_piece3), 0)
	
	press_left = 4
	press_right = 4


func hard_drop(m):
	if level <= 34:
		var dropped = false
		while not_colliding_y(m):
			change_tiles()
			position_now.y += 1
			for block in active_piece:
				if position_now.y + block.y > height or not not_colliding_y_harddrop(block):
					position_now.y -= 1
					dropped = true
			score += 2
			draw(active_piece, position_now, color_map)
			if dropped:
				break
		inc = frame_table[level-1]


func not_colliding_x(next_position):
	for block in active_piece:
		if not in_matrix_x(position_now + block + next_position):
			return false
	return true


func not_colliding_y(next_position):
	for block in active_piece:
		if not in_matrix_y(position_now + block + next_position):
			return false
	return true


func not_colliding_y_harddrop(next_position):
	return in_matrix_y(position_now + next_position)


func in_matrix_x(block_position):
	if block_position.x < 0 or block_position.x >= width:
		return false
	var tile = locked.get_cell_source_id(block_position)
	return tile == -1


func in_matrix_y(block_position):
	if block_position.y < 0 or block_position.y >= height:
		return false
	var tile = locked.get_cell_source_id(block_position)
	return tile == -1


func land():
	#delay(lock_delay)
	
	#if lock_delay <= 0:
		for i in active_piece:
			active_pieces.erase_cell(position_now+i)
			locked.set_cell(position_now+i, tileID, color_map)
		travel = 0


func delay():
	var clockwise = Input.is_action_just_pressed("Rotate Clockwise")
	var counterclockwise = Input.is_action_just_pressed("Rotate Conterclockwise")
	
	if (clockwise or counterclockwise) and presses > 0:
		lock_delay = 20
		presses -= 1
	else:
		lock_delay -= 1


func dequeue_lineup():
	for x in range(12, 17):
		for y in range(4, 18):
			active_pieces.erase_cell(Vector2i(x, y))


func clear_line(lines=0):
	var rows: int = height-1
	var is_line_clear = false
	var message = ""
	
	while rows > 0:
		var solid_blocks: int = 0
		
		for x in range(width):
			if not in_matrix_x(Vector2i(x, rows)) or not in_matrix_y(Vector2i(x, rows)):
				solid_blocks += 1
		
		if solid_blocks == width:
			floor_rows(rows)
			total_lines_cleared += 1
			lines += 1
			level_up(level, total_lines_cleared)
			is_line_clear = true
		else:
			rows -= 1
	
	$Stats.text = "Score: " + str(score)
	$Lines.text = "Lines cleared: " + str(total_lines_cleared)
	$Level.text = "Level: " + str(level) + "/50"
	
	if is_line_clear:
		if position_now.y <= 9:
			score += int(clears[line_clears[lines]] * level * 1.5)
			$ScoreLog.text += "\n" + lc[lines] + " (+" + str(int(clears[line_clears[lines]] * level * 1.5))+ ")"
		#if get_spin_bonus:
			#score += clears[line_clears[lines]] * 3
			#message = spin_ident(message, lines)
			#$ScoreLog.text += "\n" + message + " (+" + str(clears[line_clears[lines]] * level * 3)+ ")"
		else:
			score += clears[line_clears[lines]] * level
			$ScoreLog.text += "\n" + lc[lines] + " (+" + str(clears[line_clears[lines]] * level)+ ")"
		if leveled_up:
			$ScoreLog.text += "\n LEVEL UP! " + str(level-1)+ " -> " + str(level)
	is_line_clear = false
	leveled_up = false


func spin_ident(m, l):
	if current_piece == i_polyblock and l == 1:
		m = "I-spin single"
	elif current_piece == i_polyblock and l == 2:
		m = "I-spin double"
	elif current_piece == i_polyblock and l == 3:
		m = "I-spin TRIPLE"
	elif current_piece == i_polyblock and l == 4:
		m = "I-SPIN QUAD!"
	
	elif current_piece == j_polyblock and l == 1:
		m = "J-spin single"
	elif current_piece == j_polyblock and l == 2:
		m = "J-spin double"
	elif current_piece == j_polyblock and l == 3:
		m = "J-spin TRIPLE"
	
	elif current_piece == l_polyblock and l == 1:
		m = "L-spin single"
	elif current_piece == l_polyblock and l == 2:
		m = "L-spin double"
	elif current_piece == l_polyblock and l == 3:
		m = "L-spin TRIPLE"
	
	elif current_piece == s_polyblock and l == 1:
		m = "S-spin single"
	elif current_piece == s_polyblock and l == 2:
		m = "S-spin double"
	elif current_piece == s_polyblock and l == 3:
		m = "S-spin TRIPLE"
	
	elif current_piece == t_polyblock and l == 1:
		m = "T-spin single"
	elif current_piece == t_polyblock and l == 2:
		m = "T-spin double"
	elif current_piece == t_polyblock and l == 3:
		m = "T-spin TRIPLE"
	
	elif current_piece == z_polyblock and l == 1:
		m = "Z-spin single"
	elif current_piece == z_polyblock and l == 2:
		m = "Z-spin double"
	elif current_piece == z_polyblock and l == 3:
		m = "Z-spin TRIPLE"
	return m


func floor_rows(tall):
	var mat_map: Vector2i
	
	for y in range(tall, 0, -1):
		for x in range(width):
			mat_map = locked.get_cell_atlas_coords(Vector2i(x, y-1))
			
			if mat_map == Vector2i(-1, -1):
				locked.erase_cell(Vector2i(x, y))
			else:
				locked.set_cell(Vector2i(x, y), tileID, mat_map)


func level_up(lvl, l):
	if l >= lvl * 10 and lvl < 50:
		lvl += 1
		level += 1
		leveled_up = true
	if l >= 640:
		running = false
		$Panel.show()
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://scenes/exp_menu.tscn")


func hold():
	var hold_piece = current_piece[rotator]
	hold_color_map = Vector2i(pieces.find(hold_piece), 0)
	
	change_tiles()
	
	if empty:
		draw(current_piece[rotator], Vector2i(-5, 6), color_map)
		new_piece()
		draw(current_piece[rotator], start_pos, color_map)
		empty = false
	else:
		swap_hold()
		current_piece = hold_piece
		color_map = hold_color_map
		draw(hold_piece, start_pos, hold_color_map)
	
	position_now = start_pos


func swap_hold():
	for x in range(-7, -3):
		for y in range(4, 8):
			active_pieces.erase_cell(Vector2i(x, y))
	draw(current_piece[rotator], Vector2i(-5, 6), color_map)


func topout(x, y):
	for block in active_piece:
		if y + block.y < 4 and x + block.x >3 and x + block.x < 7 and not not_colliding_y(block):
			land()
			$"Panel2".visible = true
			$"Panel2/Game over".text = "TOP OUT!\nClick to restart\nYour score is: " + str(score)
			running = false
			if Input.is_action_just_pressed("ui_accept"):
				restart()


func flip():
	if current_piece == j_polyblock or current_piece == l_polyblock or current_piece == s_polyblock or current_piece == z_polyblock:
		for block in active_piece:
			active_pieces.erase_cell(position_now + block)
			block.x = -block.x
			draw(active_piece, position_now + block, color_map)


func restart():
	$"Panel2".hide()
	$ScoreLog.text = "Score Log"
	running = true
	for y in range(height):
		for x in range(-10, 20):
			locked.erase_cell(Vector2i(x, y))
	play()


func _input(button):
	if topout(position_now.x, position_now.y) and button.is_action_pressed("ui_select"):
		get_tree().change_scene_to_file("res://scenes//post_game.tscn")
	if Input.is_action_just_pressed("Fullscreen") and full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif Input.is_action_just_pressed("Fullscreen") and not full:
		full = not full
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _physics_process(_delta):
	if running:
		var level_speed: int
		var motion = Vector2i.ZERO
	
		if level < 35 and not_colliding_y(motion):
			level_speed = frame_table[level-1]
		elif level >= 35 and not_colliding_y(motion):
			level_speed = frame_table[-1]
			change_tiles()
			position_now.y += fall_distance[level-35]
		
		if Input.is_action_just_pressed("Move Left"):
			motion = Vector2i.LEFT
		if Input.is_action_just_pressed("Move Right"):
			motion = Vector2i.RIGHT
		
		if Input.is_action_pressed("Move Left") and inc % 2 == 0:
			if DAS > 0:
				DAS -= 1
			else:
				motion = Vector2i.LEFT
		if Input.is_action_pressed("Move Right") and inc % 2 == 0:
			if DAS > 0:
				DAS -= 1
			else:
				motion = Vector2i.RIGHT
		
		if Input.is_action_just_released("Move Left") or Input.is_action_just_released("Move Right"):
			DAS = 3
		
		if Input.is_action_pressed("Soft Drop") and inc % 2 == 0 and position_now.y < height and level <= 29:
			motion = Vector2i.DOWN
			if not_colliding_y(Vector2i.DOWN):
				score += 1
			$Stats.text = "Score: " + str(score)
		
		if Input.is_action_just_pressed("Hard Drop"):
			hard_drop(motion)
			inc = level_speed
		
		if Input.is_action_just_pressed("Hold") and not held:
			hold()
			held = true
		
		if Input.is_action_just_pressed("Flip") and not flipped:
			flip()
			#flipped = true
		
		if motion != Vector2i.ZERO:
			move_contol(motion)
			get_spin_bonus = false
		
		if Input.is_action_just_pressed("Rotate Clockwise") or Input.is_action_just_pressed("Rotate Conterclockwise"):
			rotate_piece()
			get_spin_bonus = true
		
		inc += 1
		if inc >= level_speed:
			move_contol(Vector2i.DOWN)
			travel += 1
			inc = 0
			get_spin_bonus = false
		
		if lock_delay > 0 and not not_colliding_y(Vector2i.DOWN):
			delay()
		
		if Input.is_action_just_pressed("Pause"):
			pause()


func pause():
	var menu = $Pause
	menu.popup_centered()
	menu.show()
	get_tree().paused = true


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
	get_tree().change_scene_to_file("res://scenes//exp_menu.tscn")
