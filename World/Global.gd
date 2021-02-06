extends Node

var player = null
var world = null

func add_child_to_world(scene, position):
	assert(world != null)
	assert(scene != null)
	
	var i = scene.instance();
	i.global_position = position
	world.add_child(i)
	
	return i
