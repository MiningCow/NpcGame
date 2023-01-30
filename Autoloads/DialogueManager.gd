extends Node

onready var dialogue_ui = get_node("/root/World/UI/DialogueUI")
var talking: bool = false
var npc

func _ready():
	dialogue_ui.connect("dialogue_ended", self, "_on_Dialogue_ended")

func begin_dialogue(dialogue, new_npc) -> void:
	if talking: return
	dialogue_ui.begin_dialogue(dialogue, new_npc)
	talking = true
	npc = new_npc

func _on_Dialogue_ended():
	talking = false
	npc = null
