extends ProgressBar

var active: bool = false


func _ready():
	GameEvents.connect("weapon_reloading", self, "_set_value")
	GameEvents.connect("player_attacked", self, "_reduce_ammo")
	visible = false

func _reduce_ammo() -> void:
	value -= 1

func _set_value(ammo_amount, max_ammo):
	visible = true
	max_value = max_ammo
	value = ammo_amount
