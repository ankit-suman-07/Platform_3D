extends Area3D

@onready var sfx_coin = $CoinPickUp

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player": # Or is_in_group("player")
		Global.score += 1
		sfx_coin.play()
		$MeshInstance3D.visible = false
		$CollisionShape3D.disabled = true
		# wait for 1 sound
		await get_tree().create_timer(0.5).timeout 
		queue_free()
