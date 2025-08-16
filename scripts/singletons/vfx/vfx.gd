extends Node

var scenes := {
	"explosion": {
		"explosion1": load("uid://c4ggga87ktx3r"),
		"circular": load("uid://bndtph6e8gcgu")
	},
	"post_collision": {
		"bullet_spark1": load("uid://c1u3fnwh771x3")
	}
}

class Explosion:
	class CircularExplosion:
		func _init(where: Vector2, thiccness := 45.0, duration := 0.5) -> void:
			var instance: Node2D = VFX.scenes.explosion.circular.instantiate()
			instance.thiccness = thiccness
			instance.duration = duration
			instance.global_position = where
			Arena.other_nodes.add_child(instance)
			
	class RegularExplosion:
		func _init(where: Vector2) -> void:
			var instance: AnimatedSprite2D = VFX.scenes.explosion.explosion1.instantiate()
			instance.global_position = where
			Arena.other_nodes.add_child(instance)
			CircularExplosion.new(where)

class PostCollision:
	class BulletSpark:
		func _init(where: Vector2, normal: Vector2, incident_angle: float) -> void:
			var instance: GPUParticles2D = VFX.scenes.post_collision.bullet_spark1.instantiate()
			instance.normal = normal
			instance.global_position = where
			instance.incident_angle = incident_angle
			Arena.other_nodes.add_child(instance)
