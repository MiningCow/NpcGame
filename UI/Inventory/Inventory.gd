extends Control

export(PackedScene) var item_slot_scene

onready var item_tip = $ItemTip
var Util = preload("res://Scripts/Util.gd")
var inventory

func _ready():
	inventory = Globals.player_reference.inventory
	inventory.connect("inventory_updated", self, "_on_Inventory_updated")
	generate_items()

func generate_items():
	for item in inventory.get_items():
		var item_slot = item_slot_scene.instance()
		item_slot.item = item
		$"%GridContainer".add_child(item_slot)
		item_slot.connect("mouse_entered", self, "show_tip", [item_slot])
		item_slot.connect("mouse_exited", self, "hide_tip")

func _on_Inventory_updated():
  Util.delete_children($"%GridContainer")
  generate_items()

func show_tip(item_slot): item_tip.show_item(item_slot.item)
func hide_tip(): item_tip.hide()

func _on_Inventory_hide():
	hide_tip()
