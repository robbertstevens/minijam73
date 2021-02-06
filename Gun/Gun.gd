extends Node2D

export var Bullet: PackedScene

var shoot_directions = {
	"ui_right": Vector2.RIGHT, 
	"ui_left": Vector2.LEFT, 
	"ui_down": Vector2.DOWN, 
	"ui_up": Vector2.UP
}

var previous_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	velocity = (position - previous_position) / delta
	previous_position = position
	
	var aim_directions = []
	
	for shoot_action in ["ui_right", "ui_left", "ui_down", "ui_up"]:
		if Input.is_action_just_pressed(shoot_action):
			aim_directions.append(shoot_action)
	
	if aim_directions.size() > 0:
		var shoot_dir = aim_directions.back()
		
		match(shoot_dir):
			"ui_right":
				rotation_degrees = 180
				$Sprite.flip_v = true
			"ui_left":
				rotation_degrees = 0
				$Sprite.flip_v = false
			"ui_up":
				rotation_degrees = 90
				$Sprite.flip_v = true
			"ui_down":
				rotation_degrees = -90
				$Sprite.flip_v = true
		
		var b = Global.add_child_to_world(Bullet, $ShootPoint.global_position)
		b.direction = shoot_directions[shoot_dir]
		b.gun_velocity = velocity
