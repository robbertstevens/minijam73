extends StaticBody2D

signal shard_added
signal shards_depleted
signal health_changed(old, new)

var shards = 0

var max_health = 10
var health = max_health setget set_health

func _ready() -> void:
	Global.machines.append(self)

func _process(_delta: float) -> void:
	if Global.shards > 0:
		if Input.is_action_just_pressed("ui_accept"):
			Global.shards -= 1
			add_shard()

func add_shard() -> void:
	shards += 1
	emit_signal("shard_added")

func set_health(val: int) -> void:
	var old = health
	health = val
	emit_signal("health_changed", old, health)
	
	
func _on_Timer_timeout() -> void:
	if shards > 0:
		shards -= 1
		set_health(health + 1)
		$Timer.start()
	else:
		emit_signal("shards_depleted")


func _on_Machine_shard_added() -> void:
	$Timer.start()
	$AnimatedSprite.playing = true
	if not Global.has_shards():
		$Sprite.hide()


func _on_Machine_shards_depleted() -> void:
	$AnimatedSprite.playing = false	


func _on_InteractionBox_area_entered(_area: Area2D) -> void:
	if Global.has_shards():
		$Sprite.show()


func _on_InteractionBox_area_exited(_area: Area2D) -> void:
	$Sprite.hide()


func _on_HurtBox_area_entered(area: Area2D) -> void:
	health -= 1

func is_alive() -> bool:
	return health > 0
