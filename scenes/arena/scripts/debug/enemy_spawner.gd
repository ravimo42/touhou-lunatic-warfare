extends Node

func _ready() -> void:
	_spawn_enemy()
	
func _spawn_enemy() -> void:
	var e: Enemy = load("uid://gfdqvqd8287m").instantiate()
	owner.add_child.call_deferred(e)
	e.global_position.x = randf_range(-200.0, 200.0)
	get_tree().create_timer(randf_range(2.0, 5.0)).timeout.connect(_spawn_enemy)
