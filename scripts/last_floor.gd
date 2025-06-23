extends StaticBody3D

@export var rotation_speed := 25.0 # Degrees per second
var mesh_node: MeshInstance3D

func _ready() -> void:
	# Get the mesh node
	mesh_node = $Area3D/MeshInstance3D
	# Connect the Area3D body_entered signal

func _process(delta: float) -> void:
	if mesh_node:
		mesh_node.rotation.y += deg_to_rad(rotation_speed) * delta

#func _on_body_entered(body: Node) -> void:
	#if body.name == "player": # Or use body.is_in_group("player") if needed
		#get_tree().change_scene("res://scenes/GameOverScene.tscn") # ✅ Change this path


func _on_area_3d_body_entered(body: Node3D) -> void:
	await get_tree().create_timer(1.0).timeout
	if body.name == "player": # Or use body.is_in_group("player") if needed
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
