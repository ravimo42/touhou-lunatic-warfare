class_name HitLabel extends Control

const META := &"hitlabel"

static func create(damage_ammount: float, node: Node2D, pos_offset := Vector2(0.0, -108.0)) -> HitLabel:
	var hl := check_hitlabel(node)
	if hl == null:
		hl = load("uid://bp6k0giylx3f3").instantiate()
		Arena.other_nodes.add_child(hl.post_marker)
		Game.ui_node.add_child(hl)
		hl.parent = node
		hl.global_position = Game.get_relative_position(node) + pos_offset
	hl.offset = pos_offset
	hl.parent.set_meta(META, hl)
	hl.damage = damage_ammount
	hl.accumulated_damage += damage_ammount
	hl.label.position.y = 0.0
	hl.post_marker.global_position = node.global_position
	AutoTween.new(hl.label_container, &"position:y", -24.0).from(0.0)
	AutoTween.new(hl.label, &"position:y", -42.0, 0.75, Tween.TRANS_QUART, Tween.EASE_IN).set_delay(1.0).finished.connect(hl.queue_free)
	return hl

static func check_hitlabel(node: Node2D) -> HitLabel:
	if node.has_meta(META):
		var hl = node.get_meta(META)
		return hl if hl != null else null
	return null

@onready var label_container := %LabelContainer
@onready var label := %Label

var offset: Vector2
var damage: float
var accumulated_damage: float
var parent: Entity
var post_marker := Node2D.new()

func _physics_process(_delta: float) -> void:
	global_position = Game.get_relative_position(parent if parent != null else post_marker) + offset
	label.text = str(roundi(accumulated_damage))
	
