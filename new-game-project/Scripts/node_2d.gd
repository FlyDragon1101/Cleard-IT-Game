extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_process(1)
	#level_up(19)
	scoring(line_clears, 1)

var inc = 0
var pos = 20
var level_num = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.

const frame_table = [60, 50, 45, 42, 40, 36, 32, 30, 27, 24, 22, 20, 18, 15, 12, 10, 9, 8, 7, 6, 5, 5, 4, 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1]
const drop_per_frame = [1, 1, 1, 1, 2, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 20]
const lock_delay = 20

func _process(delta: float) -> void:
	inc += 1
	if inc % frame_table[level_num] == 0 and pos > 0:
		pos -= 1
		print([delta, inc, pos])

#func _input(button) -> void:
	#if button.PRESS():
		#color = RED

func level_up(lvl, lines=0):
	while lines < 640:
		lines += 1
		print(lines)
		if lines >= lvl * 10 and lvl < 50:
			lvl += 1
			print("Level up: " + str(lvl))

const clears = {0: 0, 1: 100, 2: 250, 3: 600, 4: 1200}
const line_clears = [0, 1, 2, 3, 4]
const bonus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2]

func scoring(line_cleared, level, points=0, lines=0):
	var earnings = 0
	while lines < 640:
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
