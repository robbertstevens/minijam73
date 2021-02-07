extends ProgressBar

func _ready() -> void:
	pass

func _on_Timer_timeout() -> void:
	hide()

func _on_HealthBar_value_changed(value: float) -> void:
	show()
	$Timer.start()
