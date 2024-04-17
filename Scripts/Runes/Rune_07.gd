extends Rune
class_name Rune_07


func _ready():
	super._ready()
	modulate = Color(0.6,0.3,0.6)
	description = "Sacrifie une tour pour tuer toutes les 1er pièces qu'il rencontre sur chacun de ses axes de mouvement, y compris ses propres pièces"
	
func _activate_rune():
	if !global.rune_played:
			global.wait_rune = true
			global.activate_rune = self
			super._activate_rune()
			var pieces := get_tree().get_nodes_in_group("pieces")
			var board = get_tree().root.get_node("Control/Board")
			for piece in pieces:
				if piece.is_white == global.is_white_turn && piece.type == 'r':
					var placeholder = RunePlaceholder.new()
					var cell = board.get_node(NodePath(piece.name))
					cell.add_child(placeholder)
					placeholder.name = "RPH"
					placeholder.position = (cell.size/2)

func _play_rune(cell: Cell):
	var piece = cell.get_node(NodePath(cell.name))
	var board = get_tree().root.get_node("Control/Board")
	for right in range(-1,2,1):
		for down in range(-1,2,1):
			if (right !=0 || down != 0) && (right == 0 || down == 0) :
				var i = 1
				var x = piece.Current_X_Position + (i * right)
				var y = piece.Current_Y_Position + (i * down)
				while board.has_node(str(y) + "-" + str(x)): 
					var checkcell = board.get_node(str(y) + "-" + str(x))
					if checkcell.has_node(NodePath(checkcell.name)):
						var explodepiece = checkcell.get_node(NodePath(checkcell.name))
						if explodepiece.type != 'k':
							explodepiece.queue_free()
						break
					i += 1
					x = piece.Current_X_Position + (i * right)
					y = piece.Current_Y_Position + (i * down)
	piece.queue_free()
	super._play_rune(cell)
