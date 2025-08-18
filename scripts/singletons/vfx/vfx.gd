extends Node

var scenes := {
	"explosions": {
		"explosion1": load("uid://c4ggga87ktx3r"),
		"circular": load("uid://bndtph6e8gcgu")
	},
	"particles": {
		"bullet_spark1": load("uid://c1u3fnwh771x3"),
		"blood_splat1": load("uid://e4rsgij50m0i")
	}
}

class Explosion:
	class CircularExplosion:
		func _init(where: Vector2, thiccness := 45.0, duration := 0.5) -> void:
			var pool: ObjectPool = ObjectPoolService.get_pool(VFX.scenes.explosions.circular)
			var instance: Node2D = pool.claim_new()
			instance.thiccness = thiccness
			instance.duration = duration
			instance.global_position = where
			
	class RegularExplosion:
		func _init(where: Vector2) -> void:
			var pool: ObjectPool = ObjectPoolService.get_pool(VFX.scenes.explosions.explosion1)
			var instance: Node2D = pool.claim_new()
			instance.global_position = where
			CircularExplosion.new(where)

class Particles:
	class BulletSpark:
		func _init(where: Vector2, normal: Vector2, incident_angle: float) -> void:
			var pool: ObjectPool = ObjectPoolService.get_pool(VFX.scenes.particles.bullet_spark1)
			var instance: ParticlesGPU = pool.claim_new()
			instance.normal = normal
			instance.global_position = where
			instance.incident_angle = incident_angle
			
	class BloodSplat:
		func _init(where: Vector2) -> void:
			var pool: ObjectPool = ObjectPoolService.get_pool(VFX.scenes.particles.blood_splat1)
			var instance: ParticlesGPU = pool.claim_new()
			instance.global_position = where
