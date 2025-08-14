extends Projectile

const MAX_LENGTH := 640.0
const LENGTH_OFFSET := 6.0

@export var decay_speed := 0.15
@export var disable_collision_after := 1.0/60.0

@onready var _line := %Line2D
@onready var _raycast: RayCast2D = %RayCast2D
@onready var _collision_shape: SegmentShape2D = shape

var _normal: Vector2

func spawn() -> void:
	lifetime = decay_speed
	_raycast.collision_mask = get_collision_mask(collision_mask)
	_raycast_check.call_deferred()
	_trail_anim.call_deferred()
	get_tree().create_timer(disable_collision_after).timeout.connect(func():
		active = false
	)
	
func _physics_process(_delta: float) -> void:
	if !active:
		return
	collision_check.call_deferred(false, {"normal": _normal})
	query.transform = transform

func _trail_anim() -> void:
	var dur: float = (_line.points[0].x / MAX_LENGTH) * decay_speed
	AutoTween.Method.new(func(val):
		_line.points[-1].x = val,
		0.0, _line.points[0].x,
		dur, Tween.TRANS_LINEAR
	)

func _raycast_check() -> void:
	var res := _raycast.is_colliding()
	if !res or (_raycast.get_collider() is HitboxComponent and !_raycast.get_collider().active):
		_set_length(MAX_LENGTH)
		return
	_set_length(_raycast.get_collision_point().distance_to(global_position))
	_normal = _raycast.get_collision_normal()

func _set_length(val: float) -> void:
	_line.points[0].x = val+ LENGTH_OFFSET
	_collision_shape.b.x = val + LENGTH_OFFSET
