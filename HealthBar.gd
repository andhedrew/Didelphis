extends ProgressBar


func _ready():
	GameEvents.connect("player_took_damage", self, "_set_to_player_health")


func _set_to_player_health(damage_amount, player_health):
	value = player_health
