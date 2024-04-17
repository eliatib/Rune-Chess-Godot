extends Rune
class_name Rune_01

func _ready():
	super._ready()
	modulate = Color(0.3,0,0)
	description = "Fait apparaitre un pion sur une cas vide. Il ne peut pas bouger et disparait au prochain tour"
	
func _activate_rune():
	if !global.rune_played:
		global.wait_rune = true
		global.activate_rune = self
		super._activate_rune()
		var cells := get_tree().get_nodes_in_group("cells")
		for cell in cells:
			if not cell.has_node(str(cell.pos.y) + "-" +  str(cell.pos.x)):
				var placeholder = RunePlaceholder.new()
				cell.add_child(placeholder)
				placeholder.name = "RPH"
				placeholder.position = (cell.size/2)
			

func _play_rune(cell: Cell):
	var piece : Pawn = SPawn.new()
	cell.add_child(piece)
	piece.position = cell.size/2
	piece.Current_X_Position = cell.pos.x
	piece.Current_Y_Position = cell.pos.y
	piece.name = cell.name
	super._play_rune(cell)
