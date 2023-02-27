extends Node2D

export(Array, PackedScene) var drops
var has_dropped := false


func _ready():
	pass


func _physics_process(delta):
	if !has_node("Half_left") and !has_node("Half_right"):
		queue_free()
	elif has_node("Half_left"):
		if $Half_left.cut_in_half and !has_dropped:
			for item in drops:
				drop_item(item)
			has_dropped = true


func drop_item(my_drop: PackedScene) -> void:
	var dropped = my_drop.instance()
	dropped.position = global_position
	dropped.position.x += rand_range(-10, 10)
	get_parent().add_child(dropped)
	
