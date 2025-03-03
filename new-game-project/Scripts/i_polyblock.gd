extends CharacterBody2D

const speed = 30
const GRAVITY = 1
const block_size = 40

const frame_table = [60, 50, 45, 40, 36, 30, 27, 24, 20, 18, 15, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1]
const fall_distance = [2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 8, 10, 20]
var level = 1

var lock_delay = 20
var presses = 16
var inc = 0
#var col = $"res://Scripts/gameplay.gd".wall_collide()

const fall = Vector2i.DOWN
const distance = block_size
var exists = true

@export var score = 0
@onready var tile_map: TileMapLayer = $"../Playfield"
@onready var grid_size = Vector2i(48, 27)
var coords = Vector2i(0, 0)

#func level_up(lvl, lines):
	#if lines >= lvl * 10 and lvl < 50:
		#lvl += 1
		#print("Level up: " + str(lvl))
	#if lines >= 640:
		#Popup.new()
		#print("You beat the game!")


func tile_pos():
	var current_tile: Vector2i = tile_map.local_to_map(position)
	return current_tile


func _physics_process(delta):
	var level_speed = null
	if inc == 0:
		rotation_degrees = 0
	inc += 1
	
	if level < 35:
		level_speed = frame_table[level-1]
	else:
		level_speed = fall_distance[level-35]
	
	var current_tile = tile_pos()
	
	if inc % 2 == 0:
		move_contol(current_tile.x)
	
	var drop_gain = int((960 - position.y) / block_size)
	
	if Input.is_action_just_pressed("ui_left"):
		rotate_piece(-90)
	if Input.is_action_just_pressed("ui_right"):
		rotate_piece(90)
	
	if Input.is_action_just_pressed("Hard Drop"):
		position.y = 24 * block_size
		score += drop_gain * 2
	if Input.is_action_pressed("Soft Drop") and inc % 2 == 0 and not is_on_floor():
		score += 1
	
	if inc % level_speed == 0 and not is_on_floor():
		fall_speed()
	if inc % level_speed == 0 and level > 34 and not is_on_floor():
		fall_level_speed(level_speed)
	
	move_and_slide()


func fall_speed():
	position.y += GRAVITY * distance


func fall_level_speed(level_speed):
	position.y += GRAVITY * distance * level_speed


func collide_with(block):
	return block.global_position.distance_to(global_position) < 10


func fetch_score():
	return score


func rotate_piece(deg):
	rotation_degrees += deg


func move_contol(distance):
	if Input.is_action_pressed("Move Left"):
		position.x -= block_size
		distance -= 1
	if Input.is_action_pressed("Move Right"):
		position.x += block_size
		distance += 1
	if Input.is_action_pressed("Hold"):
		position.y -= block_size
		distance -= 1
	if Input.is_action_pressed("Soft Drop") and level <= 29 and not is_on_floor():
		position.y += block_size
		distance += 1


func pre_lock():
	var clockwise = Input.is_action_just_pressed("Rotate Clockwise")
	var counterclockwise = Input.is_action_just_pressed("Rotate Conterclockwise")
	if clockwise or counterclockwise and presses > 0:
		lock_delay = 20
		presses -= 1
	else:
		lock_delay -= 1


func _process(delta):
	if is_on_floor():
		pre_lock()


func _on_pause():
	var pause = get_node("res://experiments.gd")
	pause.Pause()
