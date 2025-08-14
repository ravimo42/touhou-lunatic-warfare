class_name Trail extends Line2D

var _arr_trail: Array
var _node: Node
var _max_length: int
var _last_pos := Vector2.ZERO

## Remove trail with animation
func destroy(dur := 0.5) -> void:
	AutoTween.new(
		self, "default_color:a",
		0.0, dur, Tween.TRANS_LINEAR).finished.connect(_finished, CONNECT_ONE_SHOT)
	if _node != null:
		_last_pos = _node.global_position
		_node = null

func _init(node: Node, _color := Color.WHITE, _width := 10.0, max_length := 30, curve: Curve = load("res://scripts/libs/trail/curve1.tres")) -> void:
	_node = node
	_max_length = max_length
	default_color = _color
	width = _width
	width_curve = curve
	node.tree_exited.connect(destroy)

func _physics_process(_delta: float) -> void:
	_arr_trail.push_front(_node.global_position if _node != null else _last_pos)
	if _arr_trail.size() > _max_length / Engine.time_scale:
		_arr_trail.pop_back()
	clear_points()
	for p in _arr_trail:
		add_point(p)

func _finished():
	queue_free()
