extends Position2D

enum {RIGHT, DOWN, LEFT, UP}
var starting_position = position 
func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_change_facing_direction")


func _change_facing_direction(player_facing):
	if player_facing == RIGHT: position = starting_position
	elif player_facing == LEFT:position = Vector2(starting_position.x, 0)
	elif player_facing == UP: position = Vector2(0, -starting_position.x)
	elif player_facing == DOWN:position = Vector2(0, starting_position.x)
