extends TextureRect
class_name Prom_piece

var p_type = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_texture(num : int, is_white : bool):
	var tp : String
	match num:
		0:
			if is_white:
				tp = "res://Textures/WQueen.svg"
			else:
				tp = "res://Textures/BQueen.svg"
		1:
			if is_white:
				tp = "res://Textures/WBishop.svg"
			else:
				tp = "res://Textures/BBishop.svg"
		2:
			if is_white:
				tp = "res://Textures/WKnight.svg"
			else:
				tp = "res://Textures/BKnight.svg"
		3:
			if is_white:
				tp = "res://Textures/WRook.svg"
			else:
				tp = "res://Textures/BRook.svg"
	texture = load(tp)
	p_type = num

func _gui_input(event):  
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(event.position):
			var cell : Cell= get_parent().get_parent()
			var square : prom_square = get_parent()
			var piece : Pawn
			match p_type:
				0:
					piece = Queen.new()
					piece.type = 'q'
				1:
					piece = Bishop.new()
					piece.type = 'b'
				2:
					piece = Knight.new()
					piece.type = 'n'
				3:
					piece = Rook.new()
					piece.type = 'r'
			piece.name = cell.name
			piece.texture = texture
			piece.Current_Y_Position = square.pos.y
			piece.Current_X_Position =  square.pos.x
			piece.as_move = true
			piece.is_white = global.is_white_turn
			cell.add_child(piece)
			piece.position = Vector2i(cell.cell_size/2,cell.cell_size/2)
			global.wait_prom = false
			global.change_turn()
			square.queue_free()
			
