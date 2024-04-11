@tool
extends Sprite2D
class_name CellPlaceholder

var pos : Vector2i
# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = preload("res://Textures/CirclePlaceholder.svg")
	self.name = "PlaceHolder"
	add_to_group("placeholder")
	pass # Replace with function body.

