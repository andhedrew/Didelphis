extends Area2D

export(Array, StreamTexture) var death_spritesheet = []
var executed := false
var execution_timer := 0.0

func _ready():
	GameEvents.connect("player_executed", self, "_on_player_executed")
	$Hurtbox.connect("area_entered", self, "_hitbox_area_entered")

func _process(delta):
	execution_timer -= 1*delta
	if execution_timer <= 0:
		executed = false

func _hitbox_area_entered(hitbox):
	if hitbox is HitBox and executed:
		queue_free()


func _exit_tree():
	SoundPlayer.play_sound(SoundPlayer.SLICE_SQUISH_SMALL)
	GameEvents.emit_signal("double_jump_refreshed")
	if death_spritesheet:
		var spacing = 2
		var starting_x = -(death_spritesheet.size()*(spacing*.5))
		for sprite in death_spritesheet:
			var pickup := preload("res://Pickups/FoodPickup.tscn").instance()
			pickup.pickup_texture = sprite
			pickup.position = global_position
			pickup.velocity = Vector2(starting_x, rand_range(-4, -6))
			starting_x += spacing
			get_node("/root/World").add_child(pickup)

func _on_player_executed():
	executed = true
	execution_timer = 0.5
