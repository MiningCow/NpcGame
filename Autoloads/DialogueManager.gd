extends Node

onready var dialogue_ui = get_node("/root/World/UI/DialogueUI")
var talking: bool = false

func _ready():
	dialogue_ui.connect("dialogue_ended", self, "_on_Dialogue_ended")

func begin_dialogue(dialogue) -> void:
	dialogue_ui.begin_dialogue(dialogue)
	talking = true

func _on_Dialogue_ended():
	talking = false
