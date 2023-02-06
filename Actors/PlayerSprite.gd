extends Sprite


func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_match_facing")
