extends Node2D

export(NodePath) var inventory_path
var inventory_ui

func _ready():
	inventory_ui = get_node(inventory_path)

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if event.is_action_pressed("open_inventory"):
		inventory_ui.visible = !inventory_ui.visible
