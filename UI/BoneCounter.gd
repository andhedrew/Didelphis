extends Label

var value : int = 0
func _ready():
	GameEvents.connect("player_picked_up_pickup", self, "_set_bone_amount")


func _process(delta):
	text = str("Bones: " + str(value))


func _set_bone_amount(type: String) -> void:
	if type == "bone":
		value += 1
