class_name HealthBar extends Control

const META := &"health_bar"

static func create(health_percent: float, node: Node2D, pos_offset := Vector2(0.0, -64.0)) -> HealthBar:
	var hb := check_health_bar(node)
	if hb == null:
		hb = load("uid://6sk2b2n2863p").instantiate()
		Game.ui_node.add_child(hb)
		hb.parent = node
		hb.global_position = Game.get_relative_position(node) + pos_offset
	hb.offset = pos_offset
	hb.parent.set_meta(META, hb)
	hb.progress_bar_r.value = health_percent * 100.0
	hb.modulate.a = 1.0
	AutoTween.new(hb, &"modulate:a", 0.0).set_delay(1.0)
	AutoTween.new(hb.progress_bar_o, &"value", health_percent * 100.0, 0.5, Tween.TRANS_LINEAR)
	return hb

static func check_health_bar(node: Node2D) -> HealthBar:
	if node.has_meta(META):
		var hb = node.get_meta(META)
		return hb if hb != null else null
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
