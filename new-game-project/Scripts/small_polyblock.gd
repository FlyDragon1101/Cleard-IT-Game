extends CharacterBody2D

const speed = 30
const distance = 40
const GRAVITY = 1

const frame_table = [60, 50, 45, 40, 36, 30, 27, 24, 20, 18, 15, 12, 10, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1]
const fall_distance = [2, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 8, 10, 20]
var level = 1

var lock_delay = 20
var press_l = 4
var press_r = 4
var inc = 0

@export var score = 0
@onready var tile_map: TileMapLayer = $"../Playfield"

func level_up(lvl, lines):
	if lines >= lvl * 10 and lvl < 50:
		lvl += 1
		print("Level up: " + str(lvl))
	if lines >= 640:
		Popup.new()
		print("You beat the game!")


func _physics_process(delta):
	var hold_delay = 1
	var level_speed = null
	if inc == 0:
		rotation_degrees = 0
	inc += 1
	
	if level < 35:
		level_speed = frame_table[level-1]
	else:
		level_speed = fall_distance[level-35]
	
	var current_tile: Vector2i = self.tile_map.to_local(position)
	
	if inc % 2 == 0:
		if Input.is_action_pressed("Move Left"):
			position.x -= 40
			#current_tile.x -= 1
		if Input.is_action_pressed("Move Right"):
			position.x += 40
			#current_tile.x += 1
		if Input.is_action_pressed("Hold"):
			position.y -= 40
			#current_tile.y -= 1
		if Input.is_action_pressed("Soft Drop") and level <= 29:
			position.y += 40
			#current_tile.y += 1
	
	var drop_gain = int((960 - position.y) / 40)
	
	if Input.is_action_just_pressed("ui_left") and press_l > 0:
		rotation_degrees -= 90
		press_l -= 1
	if Input.is_action_just_pressed("ui_right") and press_r > 0:
		rotation_degrees += 90
		press_r -= 1
	
	if Input.is_action_just_pressed("Pause"):
		position.y = 120
	if Input.is_action_just_pressed("Hard Drop"):
		position.y += 960
		score += drop_gain * 2
	if Input.is_action_just_pressed("Soft Drop"):
		score += drop_gain
	
	if inc % level_speed == 0 and not is_on_floor():
		position.y += GRAVITY * 40
	if inc % level_speed == 0 and level > 34 and not is_on_floor():
		position.y += GRAVITY * 40 * level_speed
	
	if lock_delay <= 0:
		#queue_free()
		tile_map.set_cell(position)
	
	move_and_slide()


func fetch_score():
	return score


func _process(delta):
	if Input.is_action_just_pressed("Move Left") or Input.is_action_just_pressed("Move Right"):
		lock_delay = 20
	else:
		if is_on_floor():
			lock_delay -= 1


func _on_playfield_changed() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	pass # Replace with function body.
