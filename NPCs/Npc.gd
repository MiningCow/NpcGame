extends StaticBody2D
class_name Npc

enum NPC_SKINS { STICK1, STICK2, TALL1, TALL2, TALL3, STICK3 }
export(NPC_SKINS) var skin
export(String, FILE, "*.json") var dialogue_path
onready var sprite = $Sprite
onready var interaction_indicator = $InteractionIndicator
var dialogue
#var player_in_range: bool = false

func _ready():
	sprite.region_rect = Rect2(skin * 350, 0, 350, 800)

	dialogue = get_dialogue()

func get_dialogue():
	var f = File.new()
	assert(f.file_exists(dialogue_path), "Dialogue file does not exist")

	f.open(dialogue_path, File.READ)

	var json = parse_json(f.get_as_text())

	f.close()

	assert(typeof(json) == TYPE_DICTIONARY)

	return json

func talk():
	interaction_indicator.visible = false
	DialogueManager.begin_dialogue(dialogue)

#func _on_TalkRange_body_entered(body):
#	if body.name == "Player":
#		player_in_range = true
#		interaction_indicator.visible = true
#
#func _on_TalkRange_body_exited(body):
#	if body.name == "Player":
#		player_in_range = false
#		interaction_indicator.visible = false
