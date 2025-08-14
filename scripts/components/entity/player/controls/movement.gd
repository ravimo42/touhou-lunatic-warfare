extends Node2D

const SPEED := 230.0
const TERMINAL_VELOCITY := 500.0
const DRAG := 1.5
const DRAG_ON_AIR := 2.5
const MULT := 3000.0

@onready var _player: Player = owner

var disabled := false
var direction: int

var _old_pos := Vector2.ZERO
var _alive := true

func _ready() -> void:
	_player.died.connect(func(): _alive = false )

func _input(_event: InputEvent) -> void:
	if Player.enable_input:
		direction = Input.get_axis(&"ui_left", &"ui_right") as int
	else:
		direction = 0
		
func _process(delta: float) -> void:
	if disabled:
		return
	if !_alive:
		_stop(delta)
		return
	_run(delta)
	_cap_to_terminal_velocity()

func _run(delta: float) -> void:
	var devider: float = DRAG if _player.is_on_floor() else DRAG_ON_AIR
	var delta_pos_player := Game.get_cursor_position().x - Player.instance.global_position.x
	var slowdown = 1.0 if direction == sign(delta_pos_player) else 0.7
	
	if !Player.enable_input:
		direction = 0
	_player.velocity.x = move_toward(
		_player.velocity.x,
		direction * SPEED * slowdown,
		delta * MULT / devider
	)
	_old_pos = _player.global_position

func _stop(delta: float) -> void:
	_player.velocity.x = move_toward(
		_player.velocity.x,
		0.0,
		delta * MULT / 10.0
	)
	if _player.is_on_floor():
		_player.velocity.x = 0.0

func _cap_to_terminal_velocity() -> void:
	_player.velocity = Vector2(
		clamp(_player.velocity.x, -TERMINAL_VELOCITY, TERMINAL_VELOCITY),
		clamp(_player.velocity.y, -TERMINAL_VELOCITY, TERMINAL_VELOCITY)
	)
