extends Rune
class_name Rune_02

func _ready():
	super._ready()
	modulate = Color(0.3,0.3,0)
	description = "Permet au cheval d'avancer de 3 case en ligne droite"

func _activate_rune():
	if !global.rune_played:
		super._activate_rune()
		var pieces := get_tree().get_nodes_in_group("pieces")
		var board = get_tree().root.get_node("Control/Board")
		for piece in pieces:
			if piece.is_white == global.is_white_turn && piece.type == 'n':
				for right in range (-1,2,1):
					for down in range (-1,2,1):
						if (right !=0 || down != 0) && (right == 0 || down == 0) :
							if board.has_node(str(piece.Current_Y_Position + (3*down) ) + "-" + str(piece.Current_X_Position + (3*right))):
								var cell = board.get_node(str(piece.Current_Y_Position + (3*down) ) + "-" + str(piece.Current_X_Position + (3*right)))
								if !cell.has_node(str(piece.Current_Y_Position + (3*down) ) + "-" + str(piece.Current_X_Position + (3*right))):
									piece.moves.append(Vector2i( piece.Current_X_Position + (3*right),  piece.Current_Y_Position + (3*down) ))
			

