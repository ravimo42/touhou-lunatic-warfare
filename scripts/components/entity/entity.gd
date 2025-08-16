@abstract class_name Entity extends CharacterBody2D

class StaticSignal:
	@warning_ignore("unused_signal")
	signal someone_got_hit

static var static_signals := StaticSignal.new()

signal died
signal damaged(ammount: float)
signal spawned
signal despawned

var hitbox_component: HitboxComponent:
	get: return %HitboxComponent
var health_component: HealthComponent:
	get: return %HealthComponent
var knockback_factor := 100.0

## Common damage behaviour
func damage(source: Node2D, ammount: float, args: Dictionary) -> void:
	damaged.emit(ammount)
	static_signals.someone_got_hit.emit()
	AutoTween.new(self, &"modulate", Color.WHITE, 0.25).from(Color.RED)
	AutoTween.new(self, &"scale", Vector2.ONE, 0.25).from(Vector2(1.05, 1.05))
	if is_on_floor():
		velocity.y = - knockback_factor
	if args.has("normal"): velocity.x = - sign(args["normal"].x) * knockback_factor
	else: velocity.x = sign((global_position - source.global_position).normalized().x) * knockback_factor

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
