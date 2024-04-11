extends Node

var is_white_player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_validate_pressed():
	var runes = get_node("choose_runes")
	for i in range(0,runes.get_child_count(),1):
		if runes.get_child(i).get_child_count() == 0:
			return null
	if !is_white_player || global.game_type == 1:
		global.in_menu = false
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
		
	else :
		get_tree().change_scene_to_file("res://Scenes/Rune_choice.tscn")
