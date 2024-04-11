@tool
extends Pawn
class_name King

func _ready():
	super()
	w_path = "res://Textures/WKing.svg"
	b_path = "res://Textures/BKing.svg"
	type = 'k'

func _calculate_move():
	var board = get_parent().get_parent()
	moves.clear()
	_possible_roc()
	for i in range(-1,2,1):
		for j in range(-1,2,1):
			var x = Current_X_Position + i
			var y = Current_Y_Position + j
			if board.has_node(str(y) + "-" + str(x)): 
				var cell = board.get_node(str(y) + "-" + str(x))
				if not cell.get_child_count() == 0:
					var Piece : Pawn
					if cell.has_node(NodePath(cell.name)):
						Piece = cell.get_node(NodePath(cell.name))
					if Piece == null:
						moves.append(Vector2i(x,y))		
					elif Piece.is_white != is_white:
						moves.append(Vector2i(x,y))		
				else:
					moves.append(Vector2i(x,y))			

func _possible_roc():
	if !as_move && !_is_check(Vector2i(Current_X_Position,Current_Y_Position)):
		var board = get_parent().get_parent()
		for right in range (-1,2,2):
			var i = 1
			var x = Current_X_Position + (right*i)
			var y = Current_Y_Position
			while board.has_node(str(y) + "-" + str(x)):
				if i<3 &&  _is_check(Vector2i(x,y)):
					break
				var cell = board.get_node(str(y) + "-" + str(x))
				if cell.has_node(NodePath(cell.name)):
					if x == 0 || x == board.board_size.x - 1 :
						var piece : Pawn = cell.get_node(NodePath(cell.name))
						if piece.type == 'r' && piece.is_white == is_white && !piece.as_move:
							moves.append(Vector2i(x,y))
					else:
						break
				i += 1
				x = Current_X_Position + (right*i)
#func _process(_delta):
	
