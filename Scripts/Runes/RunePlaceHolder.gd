@tool
extends Sprite2D
class_name RunePlaceholder


func _ready():
	self.texture = preload("res://Textures/CirclePlaceholder.svg")
	add_to_group("runeplaceholder")
