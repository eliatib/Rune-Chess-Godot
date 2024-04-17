extends Node

var runes_w : Array
var runes_b : Array

var game_type = 0
var is_white_turn = true
var wait_prom = false
var wait_rune = false
var rune_played = false
var selected_piece : Pawn
var activate_rune : Rune
var in_menu = true
var description = ""

signal turn_change


func change_turn():
	emit_signal("turn_change")
	await get_tree().create_timer(0.1).timeout
	selected_piece = null
	is_white_turn = !is_white_turn
	rune_played = false
