extends Pawn
class_name SPawn

var turn = 2

func _ready():
	is_white = global.is_white_turn
	if is_white:
		texture = load(w_path)
	else:
		texture = load(b_path)
	global.turn_change.connect(_on_turn_change)
	
func _calculate_move():
	pass
		
	
func _verify_moves():
	pass

func _show_move():
	pass
	
func _on_turn_change():
	turn -= 1
	if turn <= 0:
		queue_free()
