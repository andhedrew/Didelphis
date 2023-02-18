extends Node2D

onready var label := $Label
onready var labelbg := $bg
var label_position := Vector2.ZERO
var target := Vector2.ZERO
var damage_label : String = ""

var timer_started := false

func _process(delta):
	if !timer_started:
		$Timer.start()
		timer_started = true
		
	label.text = damage_label
	labelbg.text = damage_label
	label.rect_global_position = label_position
	labelbg.rect_global_position.x = label_position.x+1
	labelbg.rect_global_position.y = label_position.y+1
	label_position.y = lerp(label_position.y, target.y, 0.3)
	
	if $Timer.is_stopped():
		queue_free()
