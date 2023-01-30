extends Npc

func explode():
	ConditionManager.set_condition("killed_John", "true")
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("explode")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
