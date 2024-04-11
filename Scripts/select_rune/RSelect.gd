extends ReferenceRect


func _can_drop_data(_pos, data):
	return typeof(data) == typeof(TextureButton)

func _drop_data(at_position, data):
	var obj = data.duplicate()
	add_child(obj)
