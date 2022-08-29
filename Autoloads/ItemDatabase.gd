extends Node

var items = Array()
var items_dir_path = "res://Resources/Items/"

func _ready():
	var directory = Directory.new()
	directory.open(items_dir_path)
	directory.list_dir_begin()

	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			items.append(load(str(items_dir_path, filename)))
		filename = directory.get_next()

func get_item(item_id: String):
	for item in items:
		if item.id == item_id:
			return item

	return null
