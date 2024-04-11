extends TextureButton
class_name Rune

var cooldown = 3
var current_cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_normal = load("res://Textures/Runes/rupee.png")
	texture_pressed = load("res://Textures/Runes/rupee_click.png")
	texture_hover = load("res://Textures/Runes/rupee_hover.png")
	texture_disabled = load("res://Textures/Runes/rupee_disable.png")
	add_to_group("runes")
	global.turn_change.connect(_on_turn_change)

func _on_turn_change():
	current_cooldown -= 1
	if current_cooldown <= 0:
			disabled = false
	
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
	
