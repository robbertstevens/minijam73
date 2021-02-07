extends StaticBody2D

var target_position: Vector2


func _ready() -> void:
	if target_position == Vector2.ZERO:
		target_position = position 

func _process(delta: float) -> void:
	var i = lerp(position, target_position, delta)
	position = i

