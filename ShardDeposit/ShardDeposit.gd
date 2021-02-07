extends StaticBody2D

signal deposit_depleted

const SHARD_SCENE = preload("res://Shard/Shard.tscn")

var amount_of_shards_deposited = 5

func _ready() -> void:
	pass

func _on_HurtBox_area_entered(_area: Area2D) -> void:
	if amount_of_shards_deposited > 0:
		amount_of_shards_deposited -= 1
		var s = Global.add_child_to_world(SHARD_SCENE, global_position)
		s.target_position = s.position + Vector2(rand_range(-20, 20), rand_range(-20, 20))
	else:
		emit_signal("deposit_depleted")


func _on_ShardDeposit_deposit_depleted() -> void:
	$AnimatedSprite.play("depleted")
