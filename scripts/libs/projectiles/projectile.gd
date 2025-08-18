class_name Projectile extends CollisionShape2D

const UID_META := &"projectile_uid"

@export var collision_mask: Array[int]
@export var max_collision := 12
@export var can_pass_through := false

var index: int
var unique_id: int
var speed: float
var lifetime: float
var health_change: HealthComponent.ChangePackage
var payload_pool: ObjectPool

var active := false
var time: float:
	get: return Time.get_ticks_msec() - _init_time
var query := PhysicsShapeQueryParameters2D.new()

var _timer: SceneTreeTimer
var _init_time: float

func behaviour(delta: float) -> void: # Can be overwritten
	var distance = speed * delta
	var motion = transform.x * distance
	position += motion

func spawn() -> void: # Can be overwritten
	pass

func despawn() -> void:  # Can be overwritten
	pass

func explode() -> void:  # Can be overwritten
	pass

func _physics_process(delta: float) -> void:
	if !active: return
	behaviour(delta)
	collision_check(true, {&"collision_point": global_position})
	query.transform = transform

func _ready() -> void:
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.shape = shape
	_deactivate()
	Stats.spell_card.connect(func(_w,_v): _deactivate())
	
func _pool_claim() -> void:
	spawn()
	_timer = get_tree().create_timer(lifetime, false)
	_timer.timeout.connect(_deactivate)
	_init_time = Time.get_ticks_msec()
	unique_id = randi()
	active = true
	query.collision_mask = get_collision_mask(collision_mask)
	show()

func _pool_unclaim() -> void:
	despawn()
	_timer.timeout.disconnect(_deactivate)
	_timer = null
	_deactivate()

func _deactivate() -> void:
	var p := ObjectPoolService.get_pool_from_object(self)
	if p != null and p.is_claimed(self):
		ObjectPoolService.unclaim(self)
	hide()
	active = false

func get_collision_mask(num: Array[int]) -> int:
	var num_bit: int = 0
	for n in num:
		num_bit += pow(2, n-1) as int # From godot multiple layer collision documentation
	return num_bit

func collision_check(deactivate_on_collision := true, args := {}) -> Array:
	if !is_inside_tree(): return []
	var results: Array = get_world_2d().direct_space_state.intersect_shape(query, max_collision)
	for result in results:
		var collider: Node = result[&"collider"]
		if collider is not HitboxComponent:
			if deactivate_on_collision:
				explode()
				_deactivate()
			continue
		# If it is hitbox
		if !collider.active: return []
		if collider.has_meta(UID_META) and collider.get_meta(UID_META) == unique_id:
			continue
		if !can_pass_through and deactivate_on_collision:
			explode()
			_deactivate()
		args.merge({&"change_package": health_change})
		collider.set_meta(UID_META, unique_id)
		collider.hit.emit(args)
	return results
