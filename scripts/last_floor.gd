extends StaticBody3D

@export var rotation_speed := 25.0 # Degrees per second
var mesh_node: MeshInstance3D

func _ready() -> void:
	# Get the mesh node from the scene
	mesh_node = $Area3D/MeshInstance3D

func _process(delta: float) -> void:
	if mesh_node:
		mesh_node.rotation.y += deg_to_rad(rotation_speed) * delta
