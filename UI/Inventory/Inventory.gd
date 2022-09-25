extends Control

export(PackedScene) var item_slot
var Util = preload("res://Scripts/Util.gd")
var inventory

func _ready():
	inventory = Globals.player_reference.inventory
	inventory.connect("inventory_updated", self, "_on_Inventory_updated")
	generate_items()

func generate_items():
	for item in inventory.get_items():
		var new_item_slot = item_slot.instance()
		new_item_slot.item = item
		$"%GridContainer".add_child(new_item_slot)

func _on_Inventory_updated():
  Util.delete_children($"%GridContainer")
  generate_items()
