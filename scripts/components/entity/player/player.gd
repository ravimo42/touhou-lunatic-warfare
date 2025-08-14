class_name Player extends Entity

static var instance: Player
static var enable_input: bool

func _init() -> void:
	instance = self
	enable_input = true
	Camera.set_mode(Camera.MODE.FOLLOW_PLAYER)

func _process(_delta: float) -> void:
	move_and_slide()

func die() -> void:
	died.emit()
