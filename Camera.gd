extends Camera2D
 
export (NodePath) var TargetNodepath = null
var target_node
export (float) var lerpspeed = 0.05
var lead_amount = 150
var lead = lead_amount
var target_lead = lead

var noise := OpenSimplexNoise.new()
export(float, 0, .8) var trauma = 0.0
export var max_x = 150
export var max_y = 150
export var max_r = 25
export var time_scale = 150
export(float, 0, 1) var decay = 0.6
var time = 0


 
func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_change_lead_position")
	target_node  = get_node(TargetNodepath)
	
	GameEvents.connect("player_attacked", self, "_SCREENSHAKE")
	GameEvents.connect("player_executed", self, "_BIG_SCREENSHAKE")


func _process(delta):
	target_lead = lerp(target_lead, lead, 0.02)
	self.position = lerp(self.position, Vector2(target_node.position.x+target_lead, target_node.position.y), lerpspeed)
	
	
	time += delta
	
	var shake = pow(trauma, 2)
	offset.x = noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
	offset.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	if trauma > 0: trauma = clamp(trauma - (delta * decay), 0, 1)
	
 

func _change_lead_position(player_facing_dir) -> void:
	match player_facing_dir:
		Enums.Facing.RIGHT: lead = lead_amount
		Enums.Facing.LEFT: lead = -lead_amount



func add_trauma(trauma_in):
	trauma = clamp(trauma + trauma_in, 0, .8)


func _SCREENSHAKE() -> void:
	add_trauma(0.2)


func _BIG_SCREENSHAKE() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	add_trauma(0.8)


