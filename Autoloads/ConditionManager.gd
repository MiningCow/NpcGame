extends Node

signal condition_changed(condition)

var Util = preload("res://Scenes/Util.gd").new()
var global_conditions_path = "res://Narrative/GlobalConditions.json"

var _conditions = {
}

var _global_conditions = {
}

func _ready():
	_global_conditions = Util.get_json(global_conditions_path)

func set_condition(id, value):
	_conditions[id] = value
	emit_signal("condition_changed", id)

func check_condition(id, conditions = _global_conditions):
	var not_condition = id.begins_with("!")
	var condition_id = id.trim_prefix("!") if not_condition else id
	var condition = conditions[condition_id]

	for check in condition:
		match check["type"]:
			"var":
				var value = check["value"]
				if value == "false" && (!_conditions.get(check["id"]) || _conditions.get(check["id"]) == value):
					if not_condition:
						return false
				elif _conditions.get(check["id"]) == value:
					if not_condition:
						return false
				elif !not_condition:
					return false
			"item":
				var item = ItemDatabase.get_item(check["id"])
				if check["count"] <= 0 && !Globals.player_reference.inventory.has_item(item):
					if not_condition:
						return false
				elif check["count"] > 0 && Globals.player_reference.inventory.has_item(item):
					if not_condition:
						return false
				elif !not_condition:
					return false
#		match check["type"]:
#			"var":
#				if Globals.vars.get(check["id"]) == check["value"]:
#					print(id, " is ", !not_condition)
#					return !not_condition
#			"item":
#				var item = ItemDatabase.get_item(check["id"])
#				if Globals.player_reference.inventory.has_item(item):
#					print(id, " is ", !not_condition)
#					return !not_condition
	return true

func parse_text(text, conditions = _global_conditions):
	var reg = RegEx.new()
	var pattern = "{(?<condition>[^}]*):(?<true>[^}]*)\\|(?<false>[^}]*)}"

	reg.compile(pattern)
	if !reg.is_valid(): printerr("Invalid regex: ", pattern)

	var matches = reg.search_all(text)
	if !matches: return text

	for matched in matches:
		var condition = matched.get_string("condition")
		var true_text = matched.get_string("true")
		var false_text = matched.get_string("false")
		var replace = "{%s:%s|%s}" % [condition, true_text, false_text]
#		var replace = str(substr(matched.get_start(0), matched.get_end("false"))
		text = text.replace(replace, true_text if check_condition(condition, conditions) else false_text)

	return text
