extends TextureButton
class_name Rune

var cooldown = 3
var current_cooldown = 0
var description = "hello"

signal hover

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_normal = load("res://Textures/Runes/rupee.png")
	texture_pressed = load("res://Textures/Runes/rupee_click.png")
	texture_hover = load("res://Textures/Runes/rupee_hover.png")
	texture_disabled = load("res://Textures/Runes/rupee_disable.png")
	ignore_texture_size = true
	custom_minimum_size = Vector2(100,100)
	stretch_mode = TextureButton.STRETCH_SCALE
	add_to_group("runes")
	global.turn_change.connect(_on_turn_change)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_turn_change():
	current_cooldown -= 1
	if current_cooldown <= 0:
			disabled = false

func _on_mouse_entered():
	global.description = description
	
func _on_mouse_exited():
	global.description = ""

func _get_drag_data(_pos):
	
	if !global.in_menu:
		return null
	var data = self
	
	var dt = TextureRect.new()
	dt.expand = true
	dt.texture = texture_normal
	dt.size =  Vector2(100, 100)
	dt.modulate.a = 0.5
	
	var c = Control.new()
	c.add_child(dt)
	dt.position = -0.5 * dt.size
	set_drag_preview(c)

	return data

func _can_drop_data(_pos, data):
	return (typeof(data) == typeof(TextureButton) && global.in_menu && get_parent().get_parent().name == "choose_runes")

func _drop_data(at_position, data):
	var rect = get_parent()
	var obj = data.duplicate()
	rect.add_child(obj)
	queue_free()
	
func _pressed():
	if !global.rune_played && !global.in_menu:
		_activate_rune()
	
func _activate_rune():
	disabled = true
	current_cooldown = cooldown
	global.rune_played = true
	var board : Board = get_tree().get_root().get_node("Control/Board")
	board._deselect_piece()
	_give_king_invicibility()
	

func _play_rune(cell: Cell):
	global.wait_rune = false
	var pieces = get_tree().get_nodes_in_group("pieces")
	for piece in pieces:
		piece._calculate_move()
		piece._verify_moves()
	_give_king_invicibility()
	var rphs = get_tree().get_nodes_in_group("runeplaceholder")
	for rph in rphs:
		rph.queue_free()

func _give_king_invicibility():
	var board : Board = get_tree().get_root().get_node("Control/Board")	
	var king_pos = board.w_king_pos
	if global.is_white_turn:
		king_pos = board.b_king_pos
	
	var king : King = board.get_node(str(king_pos.y) + "-" + str(king_pos.x) + "/" + str(king_pos.y) + "-" + str(king_pos.x))
	king.modulate = Color(1,0.2,0.2,0.5)
	
	var pieces = get_tree().get_nodes_in_group("pieces")
	for piece in pieces:
		var i = 0
		for move in piece.moves:
			if move == king_pos:
				piece.moves.remove_at(i)
				continue
			i += 1
	
