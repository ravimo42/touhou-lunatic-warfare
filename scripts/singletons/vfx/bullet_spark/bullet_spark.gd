extends GPUParticles2D

const MAX_VELOCITY := 500.0

var normal: Vector2
var incident_angle: float
var velocity: float:
	set(val):
		var mat := process_material as ParticleProcessMaterial
		mat.initial_velocity_max = val
		mat.initial_velocity_min = val/2.0

func _ready() -> void:
	var res := Math.reflection(Vector2.from_angle(incident_angle), normal).angle()
	var i_v := Vector2.from_angle(incident_angle)
	var r_v := Vector2.from_angle(res)
	var res_v = PI - abs(i_v.angle_to(r_v))
	var res_v_normalized = remap(res_v, 0.0, PI, 0.0, 1.0)
	
	velocity = MAX_VELOCITY * res_v_normalized
	rotate(res)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	(func():
		emitting = true
	).call_deferred()
