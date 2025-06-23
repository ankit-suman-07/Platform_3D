extends Control

@onready var score_label = $ScoreLabel

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	score_label.text = "Score : " + str(Global.score)
	Global.score = 0


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
