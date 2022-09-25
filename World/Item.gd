extends Area2D
class_name Item

export(Resource) var item
onready var label = $InteractionIndicator/RichTextLabel
onready var interaction_indicator = $InteractionIndicator
#var effect: PackedScene

func _ready():
	if not item:
		item = ItemDatabase.get_item("undefined")
	$Sprite.texture = item.texture
	interaction_indicator.set_text(item.display_name)

func set_item(new_item: ItemResource) -> void :
	item = new_item
	$Sprite.texture = item.texture
	interaction_indicator.set_text(item.display_name)

func pickup(entity) -> void:
	entity.inventory.add_item(item.id, 1)

	queue_free()
