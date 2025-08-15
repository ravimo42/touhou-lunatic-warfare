class_name HealthBar extends Control

const META := &"health_bar"

static func create(health_percent: float, node: Node2D, pos_offset := Vector2(0.0, -64.0)) -> HealthBar:
	var instance := _check_instance(node)
	if instance == null:
		instance = load("uid://6sk2b2n2863p").instantiate()
		Game.ui_node.add_child(instance)
		instance.parent = node
		instance.global_position = Game.get_relative_position(node) + pos_offset
	instance.offset = pos_offset
	instance.parent.set_meta(META, instance)
	instance.progress_bar_r.value = health_percent * 100.0
	instance.modulate.a = 1.0
	AutoTween.new(instance, &"modulate:a", 0.0).set_delay(1.0)
	AutoTween.new(instance.progress_bar_o, &"value", health_percent * 100.0, 0.5, Tween.TRANS_LINEAR)
	return instance

static func _check_instance(node: Node2D) -> HealthBar:
	if node.has_meta(META):
		var instance = node.get_meta(META)
		return instance if instance != null else null
	return null

@onready var progress_bar_r: ProgressBar = %ProgressBarRed
@onready var progress_bar_o: ProgressBar = %ProgressBarOrange

var parent: Node2D
var offset: Vector2

func _physics_process(_delta: float) -> void:
	if parent == null:
		queue_free()
		set_physics_process(false)
		return
	global_position = Game.get_relative_position(parent) + offset
