extends KinematicBody2D

export (int) var speed = 60
export (PackedScene) var hit_effect;

var direction = Vector2()
var gun_velocity = Vector2()

func _ready() -> void:
	$AnimatedSprite.play("default")
	$AnimatedSprite.playing = true

func _physics_process(delta) -> void:
	var motion = gun_velocity + direction * speed
	var _collider = move_and_collide(motion * delta)

func _on_Timer_timeout() -> void:
	queue_free()

func _on_HitBox_body_entered(body: Node) -> void:
	_bullet_hit(body)

func _on_HitBox_area_entered(area: Area2D) -> void:
	_bullet_hit(area)

func _bullet_hit(_body: Node):
	Global.add_child_to_world(hit_effect, global_position)
	queue_free()
