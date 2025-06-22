extends AnimatableBody3D

@export var distance: float = 20.0
@export var speed: float = 2.0
@export var move_forward_first: bool = true

var start_position: Vector3

func _ready() -> void:
	start_position = position
	$Area3D.body_entered.connect(_on_area_body_entered)
	$Area3D.body_exited.connect(_on_area_body_exited)

func _physics_process(delta: float) -> void:
	var offset := ping_pong(Time.get_ticks_msec() / 1000.0 * speed, distance)
	var direction := 1.0 if move_forward_first else -1.0
	position = start_position + Vector3(0, 0, offset * direction)

func ping_pong(time: float, length: float) -> float:
	return length - abs(fmod(time, 2.0 * length) - length)

func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.reparent(self)

func _on_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		var parent_node = get_tree().get_current_scene()
		parent_node.add_child(body)
