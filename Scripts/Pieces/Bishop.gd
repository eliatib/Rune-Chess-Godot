@tool
extends Pawn
class_name Bishop

func _ready():
	super()
	w_path = "res://Textures/WBishop.svg"
	b_path = "res://Textures/BBishop.svg"
	type = 'b'

func _calculate_move():
	var board = get_parent().get_parent()
	moves.clear()
	for down in range(-1,2,2):
		for right in range(-1,2,2):
			var add = 1
			var x = Current_X_Position + add*right
			var y = Current_Y_Position + add*down
			while board.has_node(str(y) + "-" + str(x)): 
				var cell = board.get_node(str(y) + "-" + str(x))
				if cell.get_child_count() == 0 :
					moves.append(Vector2i(x,y))
				else :
					var Piece : Pawn
					if cell.has_node(NodePath(cell.name)):
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

#func _process(_delta):
	
