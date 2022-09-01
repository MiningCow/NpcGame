extends Npc

func explode():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("explode")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
