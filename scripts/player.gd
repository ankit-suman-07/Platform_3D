extends CharacterBody3D

const SPEED := 4.0
const GRAVITY := 9.8 * 4
const JUMP_VELOCITY := 12
const MOUSE_SENSITIVITY := 0.001
const RAY_LENGTH := 100.0
const MAX_LOOK_ANGLE := deg_to_rad(70)

var was_in_air := false

@onready var sfx_node = $JumpDropSound
@onready var sfx_node_die = $GameOverSound
#var jump_sound = preload("res://assets/sounds/drop_sound.mp3") # or .ogg
@onready var shadow_node = $ShadowMesh
@onready var camera_node = $Camera3D

var camera_pitch := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#sfx_node.stream = jump_sound

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		# Mouse X rotates the player
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		# Mouse Y rotates the camera pitch
		camera_pitch = clamp(camera_pitch - event.relative.y * MOUSE_SENSITIVITY, -MAX_LOOK_ANGLE, MAX_LOOK_ANGLE)
		camera_node.rotation.x = camera_pitch

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				get_tree().quit()

func _physics_process(delta: float) -> void:
	# ---- Gravity ----
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		was_in_air = true
	else:
		if was_in_air:
			was_in_air = false
			_check_for_platform_impact()
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	# ---- Movement ----
	var direction := Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction += Vector3.FORWARD
	if Input.is_action_pressed("back"):
		direction -= Vector3.FORWARD
	if Input.is_action_pressed("left"):
		direction -= Vector3.RIGHT
	if Input.is_action_pressed("right"):
		direction += Vector3.RIGHT

	direction = direction.normalized()
	# Movement relative to the player’s rotation
	direction = transform.basis * direction
	direction.y = 0
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()

	# ---- Check for Fall-Off ----
	if global_position.y < -30.0:
		Global.score = 0
		get_tree().reload_current_scene()
	#if global_position.y < -5.0:
		#if sfx_node:
			#sfx_node_die.play()

func _check_for_platform_impact() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		# ✅ Check if LandingSound node exists
		if collider.has_node("LandOnLongPlatform"):
			collider.get_node("LandOnLongPlatform").play()
		if collider.has_node("LandOnGrill"):
			collider.get_node("LandOnGrill").play()
		if collider.has_node("LandOnMetalPlatform"):
			collider.get_node("LandOnMetalPlatform").play()
		if collider.has_node("GameWonSound"):
			collider.get_node("GameWonSound").play()
		if collider.has_node("MovingPlatformSound"):
			collider.get_node("MovingPlatformSound").play()
		if collider is StaticBody3D and collider.has_method("depress"):
			collider.depress()
			
			# ✅ Play sound effect when the player lands
			if sfx_node:
				sfx_node.play()

func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var ray_origin = global_position
	var ray_direction = Vector3.DOWN * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_direction)
	query.collide_with_areas = false
	var result = space_state.intersect_ray(query)

	if result.size() > 0 and shadow_node:
		var position = result["position"]
		shadow_node.global_position = position + Vector3(0, 0.01, 0)
		shadow_node.visible = true
	elif shadow_node:
		shadow_node.visible = false
