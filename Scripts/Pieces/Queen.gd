@tool
extends Pawn
class_name Queen

signal calculate_move_queen(piece)

func _ready():
	super()
	w_path = "res://Textures/WQueen.svg"
	b_path = "res://Textures/BQueen.svg"
	type = 'q'

func _calculate_move():
	var board = get_parent().get_parent()
	moves.clear()
	
	# rook moves
	for right in range(-1,2,1):
		for down in range(-1,2,1):
			if (right !=0 || down != 0) && (right == 0 || down == 0) :
				var i = 1
				var x = Current_X_Position + (i * right)
				var y = Current_Y_Position + (i * down)
				while board.has_node(str(y) + "-" + str(x)): 
					var cell = board.get_node(str(y) + "-" + str(x))
					if cell.get_child_count() == 0 :
						moves.append(Vector2i(x,y))
					else :
						var Piece : Pawn
						if cell.has_node(NodePath(cell.name)) :
							Piece = cell.get_node(NodePath(cell.name))
						if Piece == null:
							moves.append(Vector2i(x,y))		
						else :
							if Piece.is_white != is_white:
								moves.append(Vector2i(x,y))		
							break
					i += 1
					x = Current_X_Position + (i * right)
					y = Current_Y_Position + (i * down)
					
	# bishop moves
	
	for down in range(-1,2,2):
		for right in range(-1,2,2):
			var add = 1
			var x = Current_X_Position + add*right
			var y = Current_Y_Position + add*down
			while board.has_node(str(y) + "-" + str(x)) : 
				var cell = board.get_node(str(y) + "-" + str(x))
				if cell.get_child_count() == 0 :
					moves.append(Vector2i(x,y))
				else :
					var Piece : Pawn
					if cell.has_node(NodePath(cell.name)) :
						Piece = cell.get_node(NodePath(cell.name))
					if Piece == null:
						moves.append(Vector2i(x,y))		
					else :
						if Piece.is_white != is_white:
							moves.append(Vector2i(x,y))		
						break
				add += 1
				x = Current_X_Position + add*right
				y = Current_Y_Position + add*down
	emit_signal("calculate_move_queen", self)
#func _process(_delta):
	
