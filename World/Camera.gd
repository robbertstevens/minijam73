extends Camera2D

func _process(_delta: float) -> void:
	if Global.player != null:
		position = lerp(position, Global.player.position, 0.2)

