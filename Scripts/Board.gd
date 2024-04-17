extends GridContainer
class_name Board

var board_size := Vector2i(8,8) 
var FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

var w_king_pos : Vector2i
var b_king_pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_board()
	_place_pieces()
	var pieces := get_tree().get_nodes_in_group("pieces")
	for piece in pieces:
		piece._set_piece()
	var w_runes = get_tree().root.get_node("Control/WR_Container")
	for path in global.runes_w:
		var rune = load(path).new()
		w_runes.add_child(rune)
	var b_runes = get_tree().root.get_node("Control/BR_Container")
	for path in global.runes_b:
		var rune = load(path).new()
		b_runes.add_child(rune)
	
func _create_board():
	for y in range(0,board_size.y,1):
		for x in range(0,board_size.x,1):
			var cell := Cell.new()
			cell.name = str(y) + "-" + str(x)
			add_child(cell)
			#cell creation
			var size_cell = get_viewport().size.x / (board_size.x+2)
			cell.cell_size = size_cell
			cell.pos = Vector2i(x,y)
			cell.custom_minimum_size = Vector2i(size_cell,size_cell)
			#cell color
			var color_rect := ColorRect.new()
			color_rect.custom_minimum_size = Vector2i(size_cell,size_cell)
			if (x+y+2)%2 == 0:
				color_rect.color = Color.WHITE
			else:
				color_rect.color = Color.BISQUE
			cell.add_child(color_rect)
			#button creation
			var button = Button.new()
			button.flat = true
			button.custom_minimum_size = Vector2i(size_cell,size_cell)
			cell.add_child(button)
			button.name = "button"
			button.pressed.connect(_on_click_cell.bind(button))
			button.modulate.a = 0
			
			cell.add_to_group("cells")

func _place_pieces():
	var x = 0
	var y = 0
	for c in FEN:
		if c == '/':
			y += 1
			x = 0
		else:
			if c.is_valid_int():
				x += c.to_int()
			else:
				var piece : Pawn
				match c.to_upper():
					'P':
						piece = Pawn.new()
					'R':
						piece = Rook.new()
					'N':
						piece = Knight.new()
					'B':
						piece = Bishop.new()
					'Q':
						piece = Queen.new()
					'K':
						piece = King.new()
						if c == c.to_lower():
							w_king_pos = Vector2i(x,y)
						else:
							b_king_pos = Vector2i(x,y)
				piece.is_white = false
				piece.type = c.to_lower()
				if c == c.to_lower():
					piece.is_white = true
				if has_node(str(y)+"-"+str(x)):
					var cell: Cell = get_node(str(y)+"-"+str(x))
					cell.add_child(piece)
					piece.position = Vector2i(cell.cell_size/2,cell.cell_size/2)
				piece.name = str(y) + "-" + str(x)
				piece.Current_X_Position = x
				piece.Current_Y_Position = y
				piece.add_to_group("pieces")
				x += 1
	
func _move_piece(pos : Vector2i):
	var piece_eaten : Pawn
	var repos
	var piece : Pawn = global.selected_piece
	var cell : Cell = get_node(str(pos.y)+"-"+str(pos.x))
	if cell.has_node(NodePath(cell.name)):
		piece_eaten = cell.get_node(NodePath(cell.name))
		if piece_eaten.type == 'r' && piece_eaten.is_white == piece.is_white:
			#case castling
			var i = 1
			if pos.x == 0:
				pos.x += 2
			else:
				pos.x -= 1
				i = - 1
			var new_cell = get_node(str(pos.y) + "-" + str(pos.x + i))
			repos = piece.position
			piece_eaten.reparent(new_cell)
			piece_eaten.position = repos
			piece_eaten.as_move = true
			piece_eaten.Current_X_Position = pos.x + i
			piece_eaten.name = str(pos.y) + "-" + str(pos.x + i)
			cell = get_node(NodePath(str(pos.y) + "-" + str(pos.x)))
			#end cas castling
		else:
			piece_eaten.name = "eaten"
			piece_eaten.queue_free()
	
	if piece.type == 'k':
		if piece.is_white:
			w_king_pos = pos
		else:
			b_king_pos = pos
	repos = piece.position
	piece.reparent(cell)
	piece.modulate.a = 1
	piece.position = repos
	piece.as_move = true
	piece.Current_X_Position = pos.x
	piece.Current_Y_Position = pos.y
	piece.name = str(pos.y) + "-" + str(pos.x)
	
	if (piece.type == 'p' && 
	((piece.is_white && pos.y == 7) || 
	(!piece.is_white && pos.y == 0))):
			global.wait_prom = true
			var ps : prom_square = prom_square.new()
			ps.pos = pos
			cell.add_child(ps)
			piece.queue_free()
	else:		
		global.change_turn()

func _on_click_cell(button : Button):
	var cell : Cell = button.get_parent()
	if !global.wait_rune && !global.wait_prom:
		if cell.has_node("PlaceHolder"):
			_move_piece(cell.pos)
			_deselect_piece()
		else:
			_deselect_piece()
			if cell.has_node(str(cell.pos.y) + "-" +  str(cell.pos.x)):
				var piece : Pawn = cell.get_node(str(cell.pos.y) + "-" +  str(cell.pos.x))
				if piece.is_white == global.is_white_turn:
					_select_piece(piece)
	elif global.wait_rune && cell.has_node("RPH"):
		var rune : Rune = global.activate_rune
		rune._play_rune(cell)

func _select_piece( piece : Pawn):
	piece.modulate.a = 0.5
	global.selected_piece = piece
	piece._show_move()		

func _deselect_piece():
	if global.selected_piece != null:
		var piece : Pawn = global.selected_piece
		piece.modulate.a = 1
		global.selected_piece = null
		_remove_ph()

func _remove_ph():
	var phs := get_tree().get_nodes_in_group("placeholder")
	for ph in phs:
		ph.queue_free()

