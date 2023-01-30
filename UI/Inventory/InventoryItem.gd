extends TextureRect

export(Resource) var item setget setItem

func setItem(newItem: Resource):
	item = newItem
	$TextureRect.texture = item.texture
