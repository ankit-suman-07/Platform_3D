extends Node3D

@onready var sfx_node_start = $GameStartSound

func _ready() -> void:
	sfx_node_start.play() # ✅ This will play the sound
