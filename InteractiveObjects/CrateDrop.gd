extends Node2D

export(Array, PackedScene) var drops
var has_dropped := false


func _ready():
	z_index = SortLayer.IN_FRONT


func _physics_process(delta):
	if !has_node("Half_left") and !has_node("Half_right"):
		call_deferred("queue_free")
	elif has_node("Half_left"):
		if $Half_left.cut_in_half and !has_dropped:
			for item in drops:
				drop_item(item)
				SoundPlayer.play_sound("SliceSquishMedium")
			has_dropped = true
	
	if has_node("Half_left") and has_node("Half_right"):
		if $Half_left.cut_in_half: $Half_right.cut_in_half = true
		if $Half_right.cut_in_half: $Half_left.cut_in_half = true
		


func drop_item(my_drop: PackedScene) -> void:
	var dropped = my_drop.instance()
	dropped.position = global_position
	dropped.position.x += rand_range(-10, 10)
	get_parent().add_child(dropped)
	
