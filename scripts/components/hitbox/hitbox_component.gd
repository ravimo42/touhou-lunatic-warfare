class_name HitboxComponent extends Area2D

## Emitted externally when something hit the hitbox
signal hit(change_package: HealthComponent.ChangePackage, args: Dictionary)

var active := true

func _ready() -> void:
	hit.connect(func(cp: HealthComponent.ChangePackage, args: Dictionary):
		var h_comp: HealthComponent = get_node("%HealthComponent")
		if h_comp == null or !active:
			return
		h_comp.apply(cp)
		args.merge({&"ammount": cp.amount})
		if owner.has_method(&"damage"):
			owner.call(&"damage", args)
	)
