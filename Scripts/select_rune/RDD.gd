extends TextureButton
class_name  RDD

func _get_drag_data(_pos):
	
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


