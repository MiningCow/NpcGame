extends KinematicBody2D
class_name Player

export(int) var speed: int = 12000
onready var sprite = $Sprite
var inventory_resource = preload("res://Resources/Inventory.gd")
var inventory: Inventory = inventory_resource.new()
var motion: Vector2 = Vector2.ZERO
var npcs_in_range := {}
var items_in_range := {}

func _physics_process(delta):
	var input_direction: Vector2 = get_input_direction();

	if input_direction != Vector2.ZERO:
		motion = input_direction * speed * delta
	else:
		motion = Vector2.ZERO
	if !DialogueManager.talking: move()

func move():
	motion = move_and_slide(motion)

func _input(event):
	if event.is_action_pressed("interact"):
		if npcs_in_range.size() && !DialogueManager.talking:
			get_closest_node(npcs_in_range).talk()
		elif items_in_range.size():
			get_closest_node(items_in_range).pickup(self)

func get_input_direction() -> Vector2:
	var input : Vector2 = Vector2()
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input.normalized()

#func _input(event):
#	if event.is_action_pressed("attack"):

func get_closest_node(nodes):
	var closest_node = nodes[nodes.keys()[0]]
	for node in nodes.values():
		var distance = node.global_position.distance_to(global_position)
		if distance < closest_node.global_position.distance_to(global_position): closest_node = node
	return closest_node

func _on_InteractionRange_body_entered(body):
	npcs_in_range[body] = body
	body.interaction_indicator.visible = true

func _on_InteractionRange_body_exited(body):
	if npcs_in_range.has(body):
# warning-ignore:return_value_discarded
		npcs_in_range.erase(body)
		body.interaction_indicator.visible = false

func _on_InteractionRange_area_entered(area):
	items_in_range[area] = area
	area.interaction_indicator.visible = true

func _on_InteractionRange_area_exited(area):
	if items_in_range.has(area):
# warning-ignore:return_value_discarded
		items_in_range.erase(area)
		area.interaction_indicator.visible = false
