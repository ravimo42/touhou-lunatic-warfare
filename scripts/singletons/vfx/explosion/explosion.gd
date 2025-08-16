extends AnimatedSprite2D

func _ready() -> void:
	play(&"main")
	animation_finished.connect(queue_free)
