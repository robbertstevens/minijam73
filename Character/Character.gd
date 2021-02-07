extends KinematicBody2D

export (int) var speed = 5
export (int) var max_health = 20


onready var animTree = $AnimationTree
onready var animState = $AnimationTree.get("parameters/playback")

enum PlayerState {
	IDLE,
	WALKING,
	ATTACK,
	HURT,
	DEAD
}

var current_state = PlayerState.IDLE
var motion = Vector2()
var health = max_health


func _ready() -> void:
	Global.player = self


func _process(_delta: float) -> void:
	var input = _get_input()
	
	match(current_state):
		PlayerState.IDLE: _idle_state(input)
		PlayerState.WALKING: _walking_state(input)
	
	
func _idle_state(input: Vector2):
	if input.length() > 0:
		_change_state(PlayerState.WALKING)
		return

	animState.travel("Idle")


func _walking_state(input: Vector2):
	if input.length() <= 0:
		_change_state(PlayerState.IDLE)
		return
	
	animTree.set("parameters/Walking/blend_position", input)
	animTree.set("parameters/Idle/blend_position", input)
	
	animState.travel("Walking")
	
	motion = move_and_slide(input * speed)


func _get_input() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	axis.y = Input.get_action_strength("ui_s") - Input.get_action_strength("ui_w")
	return axis.normalized()


func _change_state(state):
	current_state = state


func _on_PickupBox_body_entered(body: Node) -> void:
	if Global.shards >= Global.max_shards:
		return
		
	body.queue_free()
	
	Global.shards += 1


func _on_HurtBox_area_entered(area: Area2D) -> void:
	health -= 1


func is_alive() -> bool:
	return health > 0
