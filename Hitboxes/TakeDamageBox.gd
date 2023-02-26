extends Area2D
class_name HurtBox
export var display_damage_number := true

func _ready():
	connect("area_entered", self, "_display_damage_number")
	
func _display_damage_number(hitbox):
	if hitbox is HitBox and display_damage_number:
		var damage_number = preload("res://UI/damage_number.tscn").instance()
		var parent = get_parent()
		if parent is Prop:
			parent.health -= hitbox.damage
		else:
			damage_number.label_position = global_position
			damage_number.label_position.x += rand_range(-5,5)
			damage_number.label_position.y -= rand_range(13,16)
			if hitbox is HitBox:
				damage_number.damage_label = str(0 - hitbox.damage)
				parent.health -= hitbox.damage
			damage_number.target.y = damage_number.label_position.y - 32
			get_tree().get_root().add_child(damage_number)
