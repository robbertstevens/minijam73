extends StaticBody2D

const SLIME_SCENE = preload("res://Enemy/Enemy.tscn")

func _ready() -> void:
	pass


func _on_Timer_timeout() -> void:
	Global.add_child_to_world(SLIME_SCENE, global_position + Vector2(rand_range(-20, 20), rand_range(-20, 20)))
	
