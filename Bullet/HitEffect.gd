extends AnimatedSprite

func _ready() -> void:
	play("default")
	playing = true

func _on_HitEffect_animation_finished() -> void:
	queue_free()
