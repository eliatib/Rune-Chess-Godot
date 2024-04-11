extends Rune


func _activate_rune():
	if !global.rune_played:
		super._activate_rune()
		var pieces := get_tree().get_nodes_in_group("pieces")
		for piece in pieces:
			if piece.type == 'p' && piece.is_white == global.is_white_turn:
				piece.calculate_move_pawn.connect(_on_calculate_move)
				piece._calculate_move()

func _on_calculate_move(piece):
	piece.moves.clear()
	var board = piece.get_parent().get_parent()
	for i in range(-1,2,1):
		for j in range(-1,2,1):
			var x = piece.Current_X_Position + i
			var y = piece.Current_Y_Position + j
			if board.has_node(str(y) + "-" + str(x)): 
				var cell = board.get_node(str(y) + "-" + str(x))
				if cell.has_node(NodePath(cell.name)):
					var Piece : Pawn = cell.get_node(NodePath(cell.name))
					if Piece.is_white != piece.is_white:
						piece.moves.append(Vector2i(x,y))
				else:
					piece.moves.append(Vector2i(x,y))
	piece.calculate_move_pawn.disconnect(_on_calculate_move.bind(piece))
