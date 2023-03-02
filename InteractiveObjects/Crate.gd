extends DestructableObject

var cut_in_half_last_frame := false
var cut_in_half := false
export(String, "move_right", "move_left") var movement:= "move_left"
const GRAVITY := 3.9
const FRICTION := 0.5
var velocity := Vector2.ZERO

func _physics_process(delta):
	
	velocity.y += GRAVITY
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = 0
		velocity.x = lerp(velocity.x, 0, FRICTION)
		
		if cut_in_half_last_frame != cut_in_half:
			cut_in_half = true
			SoundPlayer.play_sound("SliceSquishMedium")
			if movement == "move_left":
				velocity.x -= 15
				velocity.y -= 100
			else:
				velocity.x += 15
				velocity.y -= 100
		cut_in_half_last_frame = cut_in_half


func _hitbox_area_entered(hitbox):
	if executed or cut_in_half:
		OS.delay_msec(40)
		if cut_in_half:
			queue_free()
		else:
			cut_in_half = true
			SoundPlayer.play_sound("SliceSquishMedium")
			if movement == "move_left":
				velocity.x -= 15
				velocity.y -= 100
			else:
				velocity.x += 15
				velocity.y -= 100
