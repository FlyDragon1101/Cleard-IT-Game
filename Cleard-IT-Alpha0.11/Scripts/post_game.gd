extends Node2D


var score = Game.score
var level = Game.level
var total_lines_cleared = Game.total_lines_cleared
var high_score = Game.high_score
var time = Game.time
var score_log = Game.score_log


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text += "\nYour player name is: " + Game.player_name
	
	$GameSummary.add_item(str(score))
	$GameSummary.add_item(str(level))
	$GameSummary.add_item(str(total_lines_cleared))
	$GameSummary.add_item(str(round(time)))
	#$GameSummary.add_item(score_log)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//Menu0.tscn")


func _on_save_pressed() -> void:
	var confirm = $Save/ConfirmationDialog
	confirm.popup_centered()
	confirm.show()


func _on_confirmation_dialog_confirmed() -> void:
	print("I")
