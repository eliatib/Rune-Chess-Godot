extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_p_pressed():
	global.game_type = 0
	get_tree().change_scene_to_file("res://Scenes/Rune_choice.tscn")


func _on_ia_pressed():
	global.game_type = 1
	get_tree().change_scene_to_file("res://Scenes/Rune_choice.tscn")


func _on_exit_pressed():
	get_tree().quit()
