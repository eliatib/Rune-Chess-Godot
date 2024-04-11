extends Rune

var moves : Array
var step = 0
var selectpiece : Pawn
var king : King

func _activate_rune():
	var board: Board = get_tree().root.get_node("Control/Board")
	var king_pos : Vector2i
	if global.is_white_turn:
		king_pos = board.w_king_pos
	else:
		king_pos = board.b_king_pos
	king = board.get_node(str(king_pos.y) + "-" + str(king_pos.x) + "/" + str(king_pos.y) + "-" + str(king_pos.x))
	if !global.rune_played && !king.moves.is_empty() && !king.as_move:
		global.wait_rune = true
		global.activate_rune = self
		step = 0
		super._activate_rune()
		var pieces := get_tree().get_nodes_in_group("pieces")
		for piece in pieces:
			if piece.is_white == global.is_white_turn && piece.type != 'k':
				var cell = board.get_node(str(piece.Current_Y_Position ) + "-" + str(piece.Current_X_Position))
				var placeholder = RunePlaceholder.new()
				cell.add_child(placeholder)
				placeholder.name = "RPH"
				placeholder.position = (cell.size/2)
			
func _play_rune(cell: Cell):
	if step == 0 && cell.has_node(NodePath(cell.name)):
		selectpiece = cell.get_node(NodePath(cell.name))
		var rphs = get_tree().get_nodes_in_group("runeplaceholder")
		for rph in rphs:
			rph.queue_free()
		var board: Board = get_tree().root.get_node("Control/Board")
		for move in king.moves:
			var movecell = board.get_node(str(move.y ) + "-" + str(move.x))
			var placeholder = RunePlaceholder.new()
			movecell.add_child(placeholder)
			placeholder.name = "RPH"
			placeholder.position = (movecell.size/2)
		step = 1
	elif step == 1:
		var repos = selectpiece.position
		selectpiece.reparent(cell)
		selectpiece.modulate.a = 1
		selectpiece.position = repos
		selectpiece.as_move = true
		selectpiece.Current_X_Position = cell.pos.x
		selectpiece.Current_Y_Position = cell.pos.y
		selectpiece.name = cell.name
		super._play_rune(cell)
