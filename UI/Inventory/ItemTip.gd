extends Control

onready var name_label = $ItemTip/Name
onready var description_label = $ItemTip/Description

func show_item(item: ItemResource):
	rect_position = get_viewport().get_mouse_position()
	name_label.bbcode_text = "[center]" + item.display_name + "[/center]"
	description_label.text = ConditionManager.parse_text(item.description)
	show()

func _input(event):
	if !visible: return

	if event is InputEventMouseMotion:
		rect_position = get_viewport().get_mouse_position()
