extends Node2D

@onready var _shoot_comp: ShootComponent = %ShootComponent

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		_shoot_comp.shoot()
	if event.is_action_released(&"Attack"):
		_shoot_comp.unshoot()

func _process(_delta: float) -> void:
	_shoot_comp.look_at(Game.get_cursor_position())
