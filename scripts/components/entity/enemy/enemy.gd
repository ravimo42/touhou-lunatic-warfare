class_name Enemy extends Entity

const POWER := 300.0

var dir_to_player: float:
	get: return signf(Player.instance.global_position.x - global_position.x)

func _ready() -> void:
	_jump()
	damaged.connect(func(args):
		HealthBar.create(health_component.percent, self)
		HitLabel.create(args.ammount, self)
		VFX.Explosion.CircularExplosion.new(args.collision_point, 12.0, 0.2)
		VFX.Particles.BloodSplat.new(args.collision_point)
	)

func _physics_process(delta: float) -> void:
	(func():
		if is_on_floor():
			velocity.x = 0.0
	).call_deferred()
	velocity.y = move_toward(velocity.y, 0.0, delta)
	move_and_slide()

func _jump() -> void:
	velocity.y = -POWER
	velocity.x = dir_to_player * POWER / 2.0
	get_tree().create_timer(randf_range(0.5, 2.0)).timeout.connect(_jump)
