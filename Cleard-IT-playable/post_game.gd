extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes//Menu0.tscn")
