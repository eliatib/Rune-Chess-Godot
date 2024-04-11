@tool
extends Pawn
class_name Knight

func _ready():
	super()
	w_path = "res://Textures/WKnight.svg"
	b_path = "res://Textures/BKnight.svg"
	type = 'n'

func _calculate_move():
	var board = get_parent().get_parent()
	moves.clear()
	for i in [-2,-1,1,2]:
		var y = Current_Y_Position + i
		if y >= 0 && y < 8:
			var dec : int
			match abs(i):
				2:
					dec = 1
				1:
					dec = 2
				_: 
					dec = -1
			for j in range(-1 * dec,1*dec +1,2 * dec):
				var x = Current_X_Position + j
				if x >= 0 && x < 8:
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

#func _process(_delta):
	
