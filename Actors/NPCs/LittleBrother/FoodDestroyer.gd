extends Area2D


func _ready():
	connect("body_entered", self, "_destroy_food")


func _destroy_food(food) -> void:
	pass
	food.call_deferred("queue_free")
