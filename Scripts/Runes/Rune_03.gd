extends Rune
class_name Rune_03

var freeze_time = 2
var freeze_cell : Cell

func _ready():
	super._ready()
	modulate = Color(0.7,0.8,0.9)
	description = "Gèle une pièce adverse qui ne peut pas jouer au prochain tour"

func _activate_rune():
	if !global.rune_played:
		global.wait_rune = true
		global.activate_rune = self
		super._activate_rune()
		var cells := get_tree().get_nodes_in_group("cells")
		for cell in cells:
			if cell.has_node(str(cell.pos.y) + "-" +  str(cell.pos.x)):
				var piece : Pawn = cell.get_node(str(cell.pos.y) + "-" +  str(cell.pos.x))
				if piece.is_white != global.is_white_turn:
					var placeholder = RunePlaceholder.new()
					cell.add_child(placeholder)
					placeholder.name = "RPH"
					placeholder.position = (cell.size/2)

func _on_turn_change():
	super._on_turn_change()
	freeze_time -= 1
	if freeze_time == 0 && freeze_cell != null:
		var button = freeze_cell.get_node("button")
		button.modulate.a = 0
		button.get_child(0).queue_free()
	
	
func _play_rune(cell: Cell):
	var button : Button = cell.get_node("button")
	var color_rect := ColorRect.new()
	button.modulate.a = 1
	button.button_pressed = 0
	button.focus_mode = Control.FOCUS_NONE
	color_rect.custom_minimum_size = Vector2i(cell.cell_size,cell.cell_size)
	color_rect.color = Color.CORNFLOWER_BLUE
	color_rect.modulate.a = 0.5
	color_rect.name = "freezecell"
	button.add_child(color_rect)
	color_rect.z_index = 1
	freeze_time = 2
	freeze_cell = cell
	super._play_rune(cell)
