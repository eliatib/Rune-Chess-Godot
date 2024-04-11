extends Rune

var movablePawns : Array
var step = 0

func _activate_rune():
	var pieces := get_tree().get_nodes_in_group("pieces")
	for piece in pieces:
		if piece.is_white == global.is_white_turn && piece.type == 'p' && !piece.as_move && !piece.moves.is_empty():
			movablePawns.push_back(piece)
	
	if !global.rune_played && movablePawns.size() >= 2:
			global.wait_rune = true
			global.activate_rune = self
			super._activate_rune()
			step = 0
			var board = get_tree().root.get_node("Control/Board")
			for piece in movablePawns:
				var placeholder = RunePlaceholder.new()
				var cell = board.get_node(NodePath(piece.name))
				cell.add_child(placeholder)
				placeholder.name = "RPH"
				placeholder.position = (cell.size/2)

func _play_rune(cell: Cell):
	var rphs = get_tree().get_nodes_in_group("runeplaceholder")
	var board = get_tree().root.get_node("Control/Board")
	var piece
	for rph in rphs:
		rph.queue_free()
	match step:
		0:
			selectpiece(cell)
		1:
			var piece_eaten : Pawn
			var repos
			piece = global.selected_piece
			if cell.has_node(NodePath(cell.name)):
				piece_eaten = cell.get_node(NodePath(cell.name))
				piece_eaten.name = "eaten"
				piece_eaten.queue_free()
			repos = piece.position
			piece.reparent(cell)
			piece.modulate.a = 1
			piece.position = repos
			piece.as_move = true
			piece.Current_X_Position = cell.pos.x
			piece.Current_Y_Position = cell.pos.y
			piece.name = str(cell.pos.y) + "-" + str(cell.pos.x)
			
			movablePawns.clear()
			
			var pieces := get_tree().get_nodes_in_group("pieces")
			for lpiece in pieces:
				if lpiece.is_white == global.is_white_turn && lpiece.type == 'p' && !lpiece.as_move && !lpiece.moves.is_empty():
					movablePawns.push_back(lpiece)
					
			for lpiece in movablePawns:
				var placeholder = RunePlaceholder.new()
				var pcell = board.get_node(NodePath(lpiece.name))
				pcell.add_child(placeholder)
				placeholder.name = "RPH"
				placeholder.position = (pcell.size/2)
			
			step = 2
		2:
			selectpiece(cell)
		3: 
			var piece_eaten : Pawn
			var repos
			piece = global.selected_piece
			if cell.has_node(NodePath(cell.name)):
				piece_eaten = cell.get_node(NodePath(cell.name))
				piece_eaten.name = "eaten"
				piece_eaten.queue_free()
			repos = piece.position
			piece.reparent(cell)
			piece.modulate.a = 1
			piece.position = repos
			piece.as_move = true
			piece.Current_X_Position = cell.pos.x
			piece.Current_Y_Position = cell.pos.y
			piece.name = str(cell.pos.y) + "-" + str(cell.pos.x)
			board._deselect_piece()
			global.change_turn()
			super._play_rune(cell)

func selectpiece(cell: Cell):
	var board = get_tree().root.get_node("Control/Board")
	var piece = cell.get_node(NodePath(cell.name))
	piece.modulate.a = 0.5
	global.selected_piece = piece
	for move in piece.moves:
		if move.y <= piece.Current_Y_Position + 1 && move.y >= piece.Current_Y_Position - 1:
			var placeholder = RunePlaceholder.new()
			var movecell = board.get_node(str(move.y ) + "-" + str(move.x))
			movecell.add_child(placeholder)
			placeholder.name = "RPH"
			placeholder.position = (movecell.size/2)
	step += 1
