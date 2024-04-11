extends GridContainer
class_name prom_square

var pos : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	anchor_left = 0
	anchor_right = 1
	anchor_top = 0
	anchor_bottom = 1
	var cell : Cell = get_parent()
	size = cell.size
	columns = 2
	for i in range(0,4,1):
		var rect : Prom_piece = Prom_piece.new()
		add_child(rect)
		rect._set_texture(i,global.is_white_turn)
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rect.size_flags_vertical = Control.SIZE_EXPAND_FILL


