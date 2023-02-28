extends Area2D


func _ready():
	connect("body_entered", self, "_destroy_food")


func _destroy_food(food) -> void:
	food.queue_free()
