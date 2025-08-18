@abstract class_name Entity extends CharacterBody2D

class StaticSignal:
	@warning_ignore("unused_signal")
	signal someone_got_hit

static var static_signals := StaticSignal.new()

signal died
signal damaged(args: Dictionary)
signal spawned
signal despawned

var hitbox_component: HitboxComponent:
	get: return %HitboxComponent
var health_component: HealthComponent:
	get: return %HealthComponent
var knockback_factor := 100.0

## Common damage behaviour
func damage(args: Dictionary) -> void:
	damaged.emit(args)
	static_signals.someone_got_hit.emit()
	AutoTween.new(self, &"modulate", Color.WHITE, 0.25).from(Color.RED)
	AutoTween.new(self, &"scale", Vector2.ONE, 0.25).from(Vector2(1.05, 1.05))
	velocity.x = sign((global_position - args.collision_point).normalized().x) * knockback_factor
	if is_on_floor():
		velocity.y = - knockback_factor

## Common die behaviour
func die() -> void:
	died.emit()
	hitbox_component.active = false
	VFX.Explosion.RegularExplosion.new(global_position)
	queue_free()

## Common despawn behaviour
func despawn() -> void:
	despawned.emit()
	hide()
	set_physics_process(false)
	propagate_call(&"set_physics_process", [false])

## Common spawn behavious
func spawn() -> void:
	spawned.emit()
	set_physics_process(true)
	propagate_call(&"set_physics_process", [true])
