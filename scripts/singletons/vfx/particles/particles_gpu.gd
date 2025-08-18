@abstract class_name ParticlesGPU extends GPUParticles2D

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	(func():
		emitting = true
	).call_deferred()
