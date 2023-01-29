extends Resource
class_name Inventory

signal inventory_updated

export(Array, Resource) var _items = [] setget set_items, get_items

func set_items(items: Array):
	_items = items
	emit_signal("inventory_updated", self)

func get_items():
	return _items

func has_item(item) -> bool:
	return _items.has(item)

func get_item(index: int):
	if _items:
		return _items[index]
	else:
		return null

func add_item(new_item_id: String, quantity: int):
	if quantity < 1:
		print("Adding less than 1 items to inventory")
		return

	var new_item = ItemDatabase.get_item(new_item_id)

	if not new_item:
		print("Couldn't find item ", new_item_id)
		return

	for i in quantity:
		_items.append(new_item)

	emit_signal("inventory_updated")

func remove_item(item: ItemResource) -> void:
	_items.erase(item)
	emit_signal("inventory_updated")

func remove_item_with_index(index: int) -> void:
	_items.erase(_items[index])
	emit_signal("inventory_updated")
