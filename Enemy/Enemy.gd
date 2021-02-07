extends KinematicBody2D	

signal health_changed(old, new)

export (int) var speed = 3
export (int) var health = 10
export (int) var max_health = health

onready var animTree = $AnimationTree
onready var animState = $AnimationTree.get("parameters/playback")
onready var cast = $RayCast2D

enum EnemyState {
	IDLE,
	WALKING,
	HURT
}

var motion = Vector2()
var current_state = EnemyState.IDLE

func _ready() -> void:
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	$HealthBar.hide() 

func _process(delta: float) -> void:
	cast.cast_to = Global.player.position - position
	
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.WALKING: _walking_state()
	
func _idle_state() -> void:
	if cast.is_colliding():
		if cast.get_collider().is_class("KinematicBody2D"):
			_change_state(EnemyState.WALKING)

	animState.travel("Idle")
	
func _walking_state() -> void:
	if not cast.get_collider().is_class("KinematicBody2D"):
		_change_state(EnemyState.IDLE)
		
	var input = position.direction_to(Global.player.position)
	
	animTree.set("parameters/Walking/blend_position", input)
	animTree.set("parameters/Idle/blend_position", input)
	
	animState.travel("Walking")
	
	motion = move_and_slide(input * speed)

func _hurt_state() -> void:
	var old_health = health
	health -= 1
	animState.travel("Hurt")
	emit_signal("health_changed", old_health, health)

func _on_HurtBox_area_entered(area: Area2D) -> void:
	if current_state != EnemyState.HURT:
		_change_state(EnemyState.HURT)
		_hurt_state()

func _change_state(state):
	current_state = state

func _on_Enemy_health_changed(old, new) -> void:
	$HealthBar.value = new
	if new <= 0:
		queue_free()
