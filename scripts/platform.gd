# Platform.gd
extends StaticBody3D

@export var depress_amount: float = 1.5          # Distance platform goes down
@export var depress_speed: float = 5.0            # Speed when going down
@export var recover_speed: float = 2.0            # Speed when coming back up

var original_position: Vector3
var target_position: Vector3
var depressed: bool = false

func _ready() -> void:
	original_position = global_transform.origin
	target_position = original_position

func _process(delta: float) -> void:
	var lerp_speed := recover_speed
	if depressed:
		lerp_speed = depress_speed
	global_transform.origin = global_transform.origin.lerp(target_position, delta * lerp_speed)

func depress() -> void:
	if depressed:
		return  # ✅ Prevent re-triggering
	depressed = true
	target_position = original_position + Vector3(0, -depress_amount, 0)

	await get_tree().create_timer(0.2).timeout
	restore()

func restore() -> void:
	depressed = false
	target_position = original_position
