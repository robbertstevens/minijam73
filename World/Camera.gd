extends Camera2D

func _process(delta: float) -> void:
	if Global.player != null:
		position = lerp(position, Global.player.position, 0.2)

