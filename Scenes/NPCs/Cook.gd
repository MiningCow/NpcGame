extends Npc

export(Resource) var good_mushroom
export(Resource) var poison_mushroom
onready var player_inventory: Inventory = Globals.player_reference.inventory

func poison():
	player_inventory.remove_item(poison_mushroom)
	ConditionManager.set_condition("poisoned_soup", "true")

func mushroom():
	player_inventory.remove_item(good_mushroom)
