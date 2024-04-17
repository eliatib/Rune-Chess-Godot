extends Rune
class_name Rune_08

var step = 0

func _ready():
	super._ready()
	modulate = Color(0.6,0.6,0.3)
	description = "En jouant un fou, si celui-ci mange une pièce il peux rejouer, mais il ne peut pas manger une autre pièce"
	

func _activate_rune():
	if !global.rune_played:
			var pieces := get_tree().get_nodes_in_group("pieces")
			var board = get_tree().root.get_node("Control/Board")
			for piece in pieces:
				if piece.is_white == global.is_white_turn && piece.type == 'b':
					if !piece.moves.is_empty():
						global.wait_rune = true
						global.activate_rune = self
						step = 0
						super._activate_rune()
						var placeholder = RunePlaceholder.new()
						var cell = board.get_node(NodePath(piece.name))
						cell.add_child(placeholder)
						placeholder.name = "RPH"
						placeholder.position = (cell.size/2)

func _play_rune(cell: Cell):
	var piece = cell.get_node(NodePath(cell.name))
	var board = get_tree().root.get_node("Control/Board")
	var rphs = get_tree().get_nodes_in_group("runeplaceholder")
	for rph in rphs:
		rph.queue_free()
	if step == 0:
		piece.modulate.a = 0.5
		global.selected_piece = piece
		step = 1
		for move in piece.moves:
			var movecell = board.get_node(str(move.y ) + "-" + str(move.x))
			var placeholder = RunePlaceholder.new()
			movecell.add_child(placeholder)
			placeholder.name = "RPH"
			placeholder.position = (movecell.size/2)
	elif step == 1:
		var piece_eaten : Pawn
		var repos
		piece = global.selected_piece
		if cell.has_node(NodePath(cell.name)):
			piece_eaten = cell.get_node(NodePath(cell.name))
			piece_eaten.name = "eaten"
			piece_eaten.queue_free()
			step = 2
		repos = piece.position
		piece.reparent(cell)
		piece.modulate.a = 1
		piece.position = repos
		piece.as_move = true
		piece.Current_X_Position = cell.pos.x
		piece.Current_Y_Position = cell.pos.y
		piece.name = str(cell.pos.y) + "-" + str(cell.pos.x)
		if step == 2:
			piece._calculate_move()
			for move in piece.moves:
				var movecell = board.get_node(str(move.y ) + "-" + str(move.x))
				if !movecell.has_node(str(move.y) + "-" + str(move.x)):
					var placeholder = RunePlaceholder.new()
					movecell.add_child(placeholder)
					placeholder.name = "RPH"
					placeholder.position = (movecell.size/2)
		else:
			board._deselect_piece()
			global.change_turn()
			super._play_rune(cell)
	elif step == 2:
		piece = global.selected_piece
		var repos = piece.position
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
		
