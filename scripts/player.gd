extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 9.8 * 4
const JUMP_VELOCITY = 12
const TURN_SPEED = 2.5  # radians per second

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		if Input.is_action_just_pressed("jump"):
			print("Jumping")
			velocity.y = JUMP_VELOCITY

	# Rotation input (left/right)
	if Input.is_action_pressed("left"):
		rotation.y += TURN_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation.y -= TURN_SPEED * delta

	# Forward/backward movement in facing direction
	var direction = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("back"):
		direction += transform.basis.z

	direction.y = 0  # Prevent any vertical movement in direction
	direction = direction.normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
