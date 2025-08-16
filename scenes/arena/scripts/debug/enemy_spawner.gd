extends Node

const MAX_ENEMY := 4

var enemy_arr: Array[Enemy]

func _ready() -> void:
	_spawn_enemy()
	
func _spawn_enemy() -> void:
	get_tree().create_timer(randf_range(2.0, 5.0)).timeout.connect(_spawn_enemy)
	if enemy_arr.size() >= MAX_ENEMY:
		return
	var instance: Enemy = load("uid://gfdqvqd8287m").instantiate()
	owner.add_child.call_deferred(instance)
	instance.global_position.x = randf_range(-200.0, 200.0)
	
	enemy_arr.append(instance)
	instance.tree_exited.connect(enemy_arr.erase.bind(instance))
