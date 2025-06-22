extends CharacterBody3D

const SPEED := 5.0
const GRAVITY := 9.8 * 4
const JUMP_VELOCITY := 12
const TURN_SPEED := 2  # radians per second

var was_in_air := false  # ✅ New variable to track air state

func _physics_process(delta: float) -> void:
	# ---- Gravity ----
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		was_in_air = true
	else:
		if was_in_air:
			# We just landed
			was_in_air = false
			# Check collisions only when we land
			_check_for_platform_impact()
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	# ---- Rotation ----
	if Input.is_action_pressed("left"):
		rotation.y += TURN_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation.y -= TURN_SPEED * delta

	# ---- Movement ----
	var direction := Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("back"):
		direction += transform.basis.z
	direction.y = 0
	direction = direction.normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()


func _check_for_platform_impact() -> void:
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider is StaticBody3D and collider.has_method("depress"):
			collider.depress()
