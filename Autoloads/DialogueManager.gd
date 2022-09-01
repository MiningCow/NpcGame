extends Node

onready var dialogue_ui = get_node("/root/World/UI/DialogueUI")
var talking: bool = false
var npc

func _ready():
	dialogue_ui.connect("dialogue_ended", self, "_on_Dialogue_ended")

func begin_dialogue(dialogue, npc) -> void:
	dialogue_ui.begin_dialogue(dialogue, npc)
	talking = true
	npc = npc

func _on_Dialogue_ended():
	talking = false
	npc = null
