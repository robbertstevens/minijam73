extends KinematicBody2D	

signal health_changed(old, new)

const BULLET_SCENE = preload("res://Bullet/EnemyBullet.tscn")

export (int) var speed = 3
export (int) var health = 10 setget set_health
export (int) var max_health = health
export (int) var chase_multiplier = 3
export (int) var shoot_distance = 30

onready var animTree = $AnimationTree
onready var animState = $AnimationTree.get("parameters/playback")
onready var cast = $RayCast2D

enum EnemyState {
	IDLE,
	CHASE,
	WALKING,
	ATTACK,
	HURT
}

var motion = Vector2()
var current_state = EnemyState.WALKING
var target = null


func _process(_delta: float) -> void:
	if Global.player == null:
		return
		
	cast.cast_to = Global.player.position - position
	
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.WALKING: _walking_state()
		EnemyState.CHASE: _chase_state()
		EnemyState.ATTACK: _attack_state()


func _idle_state() -> void:
	animState.travel("Idle")
	if target == null:
		_change_state(EnemyState.WALKING)
	elif target.is_class("KinematicBody2D"):
		_change_state(EnemyState.CHASE)
	else:
		_change_state(EnemyState.WALKING)

func _attack_state() -> void:
	animState.travel("Idle")
	if $Timer.is_stopped():
		var b = Global.add_child_to_world(BULLET_SCENE, $Position2D.global_position)
		b.direction = b.position.direction_to(target.global_position)
		$Timer.start()
	
	_change_state(EnemyState.IDLE)
	
	

func _walking_state() -> void:
	var path = _get_path_to_machine()
	
	var next_point = get_next_point(path)
	
	if next_point == null:
		_change_state(EnemyState.IDLE)
		return
	
	if _distance_to_target() < shoot_distance:
		_change_state(EnemyState.ATTACK)
		return
	
	var input = (next_point - position).normalized()
	
	animTree.set("parameters/Walking/blend_position", input)
	animTree.set("parameters/Idle/blend_position", input)
	
	animState.travel("Walking")
	
	motion = move_and_slide(input.normalized() * speed)

func _chase_state() -> void:
	if not cast.get_collider().is_class("KinematicBody2D"):
		_change_state(EnemyState.WALKING)
	
	if _distance_to_target() < shoot_distance:
		_change_state(EnemyState.ATTACK)
		return
	
	var input = position.direction_to(Global.player.position)
	
	animTree.set("parameters/Walking/blend_position", input)
	animTree.set("parameters/Idle/blend_position", input)
	
	animState.travel("Walking")
	
	motion = move_and_slide(input * speed * chase_multiplier)


func _distance_to_target() -> float:
	return global_position.distance_to(target.position)

func set_health(val: int) -> void:
	var old_value = health
	health = val
	emit_signal("health_changed", old_value, health)


func _hurt_state() -> void:
	set_health(health - 1)
	animState.travel("Hurt")

func _on_HurtBox_area_entered(area: Area2D) -> void:
	target = Global.player
	_change_state(EnemyState.HURT)
	_hurt_state()

func _change_state(state):
	current_state = state

func _get_path_to_machine() -> PoolVector2Array:
	target = Global.machines.front()
	
	if target == null:
		_change_state(EnemyState.IDLE)
	
	return Global.nav.get_simple_path(global_position, target.global_position)
	
func get_next_point(path: PoolVector2Array) -> Vector2:
	if path.size() <= 0:
		_change_state(EnemyState.IDLE)
		
	path.remove(0)
	
	for i in path:
		return i

func _on_Enemy_health_changed(_old, new) -> void:
	if new > 0:
		return
	
	queue_free()
