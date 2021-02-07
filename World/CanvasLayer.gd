extends CanvasLayer

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	$GameOverPanel.hide()

func _process(delta: float) -> void:
	if Global.is_game_over():
		get_tree().paused = true
		$GameOverPanel.show()
		
		if Input.is_action_just_pressed("ui_accept"):
			Global.reset()
