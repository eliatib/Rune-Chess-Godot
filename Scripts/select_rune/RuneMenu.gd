extends Node

var is_white_player = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if global.runes_w.is_empty():
		is_white_player = true

func _on_validate_pressed():
	var runes = get_node("choose_runes")
	for i in range(0,runes.get_child_count(),1):
		if runes.get_child(i).get_child_count() == 0:
			if is_white_player:
				global.runes_w.clear()
			else:
				global.runes_b.clear()
			return null
		else:
			if is_white_player:
				global.runes_w.append(runes.get_child(i).get_child(0).get_script().get_path())
			else:
				global.runes_b.append(runes.get_child(i).get_child(0).get_script().get_path())
	if !is_white_player || global.game_type == 1:
		global.in_menu = false
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
		
	else :
		get_tree().change_scene_to_file("res://Scenes/Rune_choice.tscn")
