extends DestructableObject


func _hitbox_area_entered(hitbox):
	if hitbox is HitBox and executed:
		queue_free()

