extends StaticBody2D
class_name Npc

export(String, FILE, "*.json") var dialogue_path
var Util = preload("res://Scenes/Util.gd").new()
onready var sprite = $Sprite
onready var interaction_indicator = $InteractionIndicator
var dialogue
#var player_in_range: bool = false

func _ready():
	dialogue = Util.get_json(dialogue_path)
	interaction_indicator.set_text(name)

func talk():
	interaction_indicator.visible = false
	DialogueManager.begin_dialogue(dialogue, self)

#func _on_TalkRange_body_entered(body):
#	if body.name == "Player":
#		player_in_range = true
#		interaction_indicator.visible = true
#
#func _on_TalkRange_body_exited(body):
#	if body.name == "Player":
#		player_in_range = false
#		interaction_indicator.visible = false
