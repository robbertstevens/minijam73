extends Node

var player: KinematicBody2D = null
var machines: Array = []
var world: YSort = null
var nav: Navigation2D = null

var shards = 0
var max_shards = 3

func add_child_to_world(scene, position):
	assert(world != null)
	assert(scene != null)
	
	var i = scene.instance();
	i.global_position = position
	world.call_deferred("add_child", i)
	
	return i

func has_shards() -> bool:
	return shards > 0

func get_nodes_in_group(name: String) -> Array:
	return world.get_tree().get_nodes_in_group(name)

func is_game_over() -> bool:
	if player != null && !player.is_alive():
		return true
	
	for machine in machines:
		if machine.is_alive():
			return false
				
	return true

func reset() -> void:
	player = null
	machines = []
	nav = null
	world.get_tree().change_scene("res://World/World.tscn")
	get_tree().paused = false
