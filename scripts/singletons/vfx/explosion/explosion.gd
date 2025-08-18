extends AnimatedSprite2D

func _ready() -> void:
	hide()

func _pool_claim() -> void:
	show()
	play(&"main")
	animation_finished.connect(_disable)

func _pool_unclaim() -> void:
	hide()
	if animation_finished.is_connected(_disable):
		animation_finished.disconnect(_disable)

func _disable() -> void:
	ObjectPoolService.unclaim(self)
