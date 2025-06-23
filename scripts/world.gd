extends Node3D

@onready var sfx_node_start = $GameStartSound
@onready var score_label = $CanvasLayer/ScoreLabel

func _ready() -> void:
	sfx_node_start.play()

func _process(delta: float) -> void:
	score_label.text = "Score : " + str(Global.score)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
