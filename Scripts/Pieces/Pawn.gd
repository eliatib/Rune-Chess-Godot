@tool
extends Sprite2D
class_name Pawn

@export var Current_X_Position : int
@export var Current_Y_Position : int

@export var moves : Array
@export var is_white : bool

var w_path = "res://Textures/WPawn.svg"
var b_path = "res://Textures/BPawn.svg"

var as_move = false
var type = 'p'

signal calculate_move_pawn(piece)

func _ready():
	global.turn_change.connect(_on_turn_change)

func _on_turn_change():
	_calculate_move()
	_verify_moves()
	if type == 'k':
		modulate = Color(1,1,1,1)
	
func _set_piece():
	texture = load(b_path)
	if is_white:
		texture = load(w_path)
	_calculate_move()
	_verify_moves()

func _calculate_move():
	var board = get_parent().get_parent()
	var sens : int
	if not is_white :
		sens = -1
	else:
		sens = 1
		
	moves.clear()
	if board.has_node(str(Current_X_Position) + "-" + str(Current_Y_Position + sens)):
		var cell = board.get_node(str(Current_Y_Position + sens) + "-" + str(Current_X_Position))
		if not cell.has_node(NodePath(cell.name)):
			moves.append(Vector2i( Current_X_Position,  Current_Y_Position + sens))
			if not as_move && board.has_node(str(Current_X_Position) + "-" + str(Current_Y_Position + sens*2)):
				cell = board.get_node(str(Current_Y_Position + sens*2) + "-" + str(Current_X_Position))
				if not cell.has_node(NodePath(cell.name)):
					moves.append(Vector2i( Current_X_Position,  Current_Y_Position + sens*2 ))

	
	for i in range(-1,2,2):
		if board.has_node(str(Current_X_Position+i) + "-" + str(Current_Y_Position+sens)):
			var cell = board.get_node(str(Current_Y_Position+sens) + "-" + str(Current_X_Position + i ))
			if cell.has_node(NodePath(cell.name)):
				var Piece : Pawn = cell.get_node(NodePath(cell.name))
				if Piece.is_white != is_white:
					moves.append(Vector2i( Current_X_Position + i,  Current_Y_Position+sens))
	emit_signal("calculate_move_pawn", self)


func _show_move():
	var board = get_parent().get_parent()
	for i in range(0,moves.size(),1):
		var cell = board.get_node(str(moves[i].y) + "-" + str(moves[i].x))
		var placeholder = CellPlaceholder.new()
		placeholder.position = (cell.size/2)
		placeholder.pos = moves[i]
		cell.add_child(placeholder)
#func _process(_delta):
	
func _verify_moves():
	if is_white == global.is_white_turn && !moves.is_empty():
		var i = 0
		while i < moves.size():
			if(_is_check(moves[i])):
				moves.pop_at(i)
			else:
				i+=1
		
func _is_check(move : Vector2i) -> bool:
	var board: Board = get_parent().get_parent()
	var king_pos : Vector2i
	if global.is_white_turn:
		king_pos = board.w_king_pos
	else:
		king_pos = board.b_king_pos
		
	if type == 'k':
		king_pos = move
	
	#Q,R, K
	var line = king_pos.y
	var col = king_pos.x
	for right in range(-1,2,1):
		for down in range(-1,2,1):
			if (right != 0 || down != 0) && (right == 0 || down == 0):
				var i = 1
				while (line + (i * down) >= 0 && line + (i * down) < 8 
				&& col + (i * right) >= 0 && col + (i * right) < 8):
					var y = line + (i * down)
					var x = col + (i * right)
					i+=1
					var piece;
					if board.has_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x)):
						piece = board.get_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x))
					if piece == null || (x == Current_X_Position && y == Current_Y_Position):
						continue
					elif x == move.x && y == move.y:
						break
					else:
						if piece.type == 'r' &&  piece.is_white != global.is_white_turn:
							return true
						elif piece.type == 'q' &&  piece.is_white != global.is_white_turn:
							return true
						elif i==1 && piece.type == 'k' && piece.is_white != global.is_white_turn:
							return true
					break
					
	#P,B,Q,K
	for right in range(-1,2,2):
		for down in range(-1,2,2):
			var i = 1
			while (line + (i * down) >= 0 && line + (i * down) < 8 
			&& col + (i * right) >= 0 && col + (i * right) < 8):
				var y = line + (i * down)
				var x = col + (i * right)
				i+=1
				var piece;
				if board.has_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x)):
					piece = board.get_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x))
				if piece == null || (x == Current_X_Position && y == Current_Y_Position):
					continue
				elif x == move.x && y == move.y:
					break
				else: 
					var sens = 1
					if not piece.is_white:
						sens = -1
					
					if piece.type == 'b' &&  piece.is_white != global.is_white_turn:
						return true
					elif piece.type == 'q' &&  piece.is_white != global.is_white_turn:
						return true
					elif i==2 && piece.type == 'k' && piece.is_white != global.is_white_turn:
						return true
					elif i==2 && piece.type == 'p' && down != sens && piece.is_white != global.is_white_turn:
						return true
				break
	
	#N
	for i in range(-2,3,1):
		var y = line + i
		if y >= 0 && y < 8:
			var dec = abs(i)
			if dec == 2:
				dec = 1
			elif dec == 1:
				dec = 2
			else:
				dec = -1
			
			var j = -dec
			while j <= dec:
				var x = col + j
				j += 2*dec
				if x in range(0,8):
					var piece;
					if board.has_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x)):
						piece = board.get_node(str(y) + "-" + str(x) + "/" + str(y) + "-" + str(x))
					if piece == null || (x == Current_X_Position && y == Current_Y_Position):
						continue
					elif piece is Knight && piece.is_white != global.is_white_turn:
						return true
					break
	return false
	

