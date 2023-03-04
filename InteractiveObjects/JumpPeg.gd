extends DestructableObject

func _hitbox_area_entered(hitbox):
	if hitbox is HitBox and executed:
		_set_inactive()

func _set_inactive() -> void:
	if active:
		SoundPlayer.play_sound("poof")
		GameEvents.emit_signal("double_jump_refreshed")
		$AnimationPlayer.play("inactive")
		active = false
		yield(get_tree().create_timer(5), "timeout")
		$AnimationPlayer.play("idle")
		SoundPlayer.play_sound("click")
		active = true
	
