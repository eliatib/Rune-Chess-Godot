@tool
extends Pawn
class_name Rook

var Castling = true

func _ready():
	super()
	w_path = "res://Textures/WRook.svg"
	b_path = "res://Textures/BRook.svg"
	type = 'r'
	
func _calculate_move():
	var board = get_parent().get_parent()
	moves.clear()
	
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
						if !cell.has_node(NodePath(cell.name)):
							moves.append(Vector2i(x,y))		
						else :
							var Piece : Pawn = cell.get_node(NodePath(cell.name))
							if Piece.is_white != is_white:
								moves.append(Vector2i(x,y))		
							break
					i += 1
					x = Current_X_Position + (i * right)
					y = Current_Y_Position + (i * down)
#func _process(_delta):
	
