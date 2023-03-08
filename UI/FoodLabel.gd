extends Label

var value : int = 0
func _ready():
	GameEvents.connect("player_picked_up_pickup", self, "_set_food_amount")


func _process(_delta):
	text = str("Food: " + str(value))


func _set_food_amount(type: String) -> void:
	if type == "food":
		value += 1
	elif type == "food_lost":
		value -= 1
