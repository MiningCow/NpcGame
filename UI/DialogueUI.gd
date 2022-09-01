extends Control

signal dialogue_ended

var button_scene = preload("res://UI/DialogueButton/DialogueButton.tscn")
var continue_button_scene = preload("res://UI/DialogueButton/ContinueButton.tscn")
export(float) var text_speed = 0.1
export(float) var punctuation_speed = 0.2
onready var animation_player = $AnimationPlayer
onready var label = $TextureRect/MarginContainer/VBoxContainer/RichTextLabel
onready var button_container = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer
onready var timer = $Timer
var npc
var dialogue
var passage
var links
var next

func _ready():
	pass

func begin_dialogue(dialogue, npc):
	self.npc = npc
	self.dialogue = dialogue
	label.text = ""
	var starting_passage = get_starting_passage(dialogue)

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

	label.bbcode_text = parse_text(passage["text"])

	remove_options()
	load_options()

	var set = passage.get("set")
	if set: set_var(set["id"], set["value"])

	var execute = passage.get("execute")
	if execute: npc.call(execute)

	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		label.visible_characters += 1

		if Input.is_action_pressed("interact"): label.visible_characters = len(label.text)

		var character = label.text[label.visible_characters-1]
		var punctuation = character == "." || character == "!" || character == "?"
		timer.start(punctuation_speed if punctuation else text_speed)
		yield(timer, "timeout")

	show_buttons()

func get_starting_passage(full_dialogue):
	var start = full_dialogue["start"]
	if start.size() == 1: return start["start"]

	for condition in start:
		if condition != "start" && check_condition(condition): return start[condition]
	return dialogue["start"]["start"]

func remove_options():
	for button in button_container.get_children(): button.queue_free()

func load_options():
	if links:
		for option in links:
			var condition = option.get("condition")
			if condition && !check_condition(condition): continue
			var button = button_scene.instance()
			button.get_node("Label").text = option.text
			button.visible = false
			button.id = option["link"]
			button.connect("pressed", self, "_on_Button_pressed", [button])
			button_container.add_child(button)
	else:
		var button = continue_button_scene.instance()
		button.get_node("Label").text = "Continue" if next else "Exit"
		button.visible = false
		button.connect("pressed", self, "_on_ContinueButton_pressed")
		button_container.add_child(button)

func check_condition(id):
	var not_condition = id.begins_with("!")
	var condition_id = id.trim_prefix("!") if not_condition else id
	var condition = dialogue["conditions"][condition_id]

	for check in condition:
		match check["type"]:
			"var":
				if Globals.vars.get(check["id"]) == check["value"]:
					print(id, " is ", !not_condition)
					return !not_condition
			"item":
				var item = ItemDatabase.get_item(check["id"])
				if Globals.player_reference.inventory.has_item(item):
					print(id, " is ", !not_condition)
					return !not_condition
	print(id, " is ", not_condition)
	return not_condition

func set_var(id, value):
	Globals.vars[id] = value

func parse_text(text):
	var reg = RegEx.new()
	var pattern = "{(?<condition>[^}]*):(?<true>[^}]*)\\|(?<false>[^}]*)}"

	reg.compile(pattern)
	if !reg.is_valid(): printerr("Invalid regex: ", pattern)

	var matches = reg.search_all(text)
	if !matches: return text

	print(matches)
	for matched in matches:
		var condition = matched.get_string("condition")
		var true_text = matched.get_string("true")
		var false_text = matched.get_string("false")
		var replace = "{%s:%s|%s}" % [condition, true_text, false_text]
#		var replace = str(substr(matched.get_start(0), matched.get_end("false"))
		text = text.replace(replace, true_text if check_condition(condition) else false_text)

	return text

func show_buttons():
	for button in button_container.get_children(): button.visible = true

func _on_Button_pressed(button):
	next_passage(button.id)

func _on_ContinueButton_pressed():
	if next:
		next_passage(next)
	else:
		end_dialogue()
