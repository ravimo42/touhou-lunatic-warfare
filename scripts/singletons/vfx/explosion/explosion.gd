extends AnimatedSprite2D

var thiccness := 45.0
var duration := 0.5

var _radius: float = 0.0
var _thickness: float:
	set(val): _thickness = clampf(val, 0.0, INF)

func _ready() -> void:
	global_rotation = randf_range(-PI, PI)
	scale = Vector2.ONE * 1.5
	play(&"main")
	#animation_
	AutoTween.Method.new(func(val):
		_radius = val
		_thickness = (thiccness - val)/5.0
		queue_redraw()
	, 0.0, thiccness, duration).finished.connect(queue_free)

func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Color.WHITE, false, _thickness)
