class_name Cursor extends Node2D

enum STATE {AIM, CURSOR}

static var instance: Cursor
static var state: STATE

@onready var _hitmarker := %HitMarker

func _init() -> void:
	instance = self
	state = STATE.CURSOR
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _ready() -> void:
	_hitmarker.modulate.a = 0.0
	Entity.static_signals.someone_got_hit.connect(func():
		_hitmarker.show()
		_hitmarker.modulate.a = 1.0
		AutoTween.new(_hitmarker, &"scale", Vector2.ONE, 0.3).from(Vector2(1.2, 1.2))
		AutoTween.new(_hitmarker, &"modulate:a", 0.0, 0.3).set_delay(0.2)
	)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
