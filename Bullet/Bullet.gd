extends KinematicBody2D

export (int) var speed = 60

var direction = Vector2()
var gun_velocity = Vector2()

func _ready() -> void:

	$AnimatedSprite.play("default")
	$AnimatedSprite.playing = true

func _physics_process(delta) -> void:
	var motion = gun_velocity + direction * speed
	var collider = move_and_collide(motion * delta)

func _on_Timer_timeout() -> void:
	queue_free() # Replace with function body.
