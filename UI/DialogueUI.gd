extends Control

signal dialogue_ended

var button_scene = preload("res://UI/DialogueButton/DialogueButton.tscn")
var continue_button_scene = preload("res://UI/DialogueButton/ContinueButton.tscn")
export(float) var text_speed = 0.1
export(float) var punctuation_speed = 0.2
export(float) var pause_speed = 0.25
onready var animation_player = $AnimationPlayer
onready var label = $TextureRect/MarginContainer/VBoxContainer/RichTextLabel
onready var button_container = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer
onready var name_label = $"%NameLabel"
onready var timer = $Timer
var npc
var dialogue
var passage
var links
var next
var conditions

func begin_dialogue(new_dialogue, new_npc):
	dialogue = new_dialogue
	npc = new_npc
	conditions = new_dialogue["conditions"]
	name_label.bbcode_text = "[center]%s[/center]" % dialogue["name"]
	label.text = ""
	var starting_passage = get_starting_passage(new_dialogue)

	animation_player.play("up")
	yield(animation_player, "animation_finished")
	next_passage(starting_passage)

func end_dialogue():
	animation_player.play("down")
	emit_signal("dialogue_ended")
	remove_options()

func next_passage(id):
	passage = dialogue["passages"][id]
	links = passage.get("links")
	next = passage.get("next")

	label.bbcode_text = ConditionManager.parse_text(passage["text"], conditions)

	remove_options()
	load_options()

	var set = passage.get("set")
	if set: ConditionManager.set_condition(set["id"], set["value"])

	var execute = passage.get("execute")
	if execute:
		if npc.has_method(execute):
			npc.call(execute)
		else:
			printerr("NPC '%s' doesn't have method '%s'" % [npc.name, execute]);

	label.visible_characters = 0

	while label.visible_characters < len(label.text):
		if label.text[label.visible_characters] == "_":
			var new_string = label.bbcode_text
			new_string.erase(label.visible_characters, 1)
			label.bbcode_text = new_string
		else:
			label.visible_characters += 1

		if Input.is_action_pressed("interact"):
			label.bbcode_text = label.bbcode_text.replace("_", "")
			label.visible_characters = len(label.text)

		var character = label.text[label.visible_characters-1]
		var punctuation = character == "." || character == "," || character == "!" || character == "?"
		var wait_time = text_speed

		if punctuation:
			wait_time = punctuation_speed
		elif character == '_':
			wait_time = pause_speed

		timer.start(wait_time)
		yield(timer, "timeout")

	show_buttons()

func get_starting_passage(full_dialogue):
	var start = full_dialogue["start"]
	if start.size() == 1: return start["start"]

	for condition in start:
		if condition != "start" && ConditionManager.check_condition(condition, conditions): return start[condition]
	return dialogue["start"]["start"]

func remove_options():
	for button in button_container.get_children(): button.queue_free()

func load_options():
	if links:
		for option in links:
			var condition = option.get("condition")
			if condition && !ConditionManager.check_condition(condition, conditions): continue
			var button = button_scene.instance()
			button_container.add_child(button)
			button.set_text(option.text)
			button.visible = false
			button.id = option["link"]
			button.connect("pressed", self, "_on_Button_pressed", [button])
	else:
		var button = continue_button_scene.instance()
		button_container.add_child(button)
		button.set_text("Continue" if next else "Exit")
		button.visible = false
		button.connect("pressed", self, "_on_ContinueButton_pressed")

func show_buttons():
	for button in button_container.get_children(): button.visible = true

func _on_Button_pressed(button):
	next_passage(button.id)

func _on_ContinueButton_pressed():
	if next:
		next_passage(next)
	else:
		end_dialogue()
