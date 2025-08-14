class_name HitboxComponent extends Area2D

## Emitted externally when something hit the hitbox
signal hit(source: Node2D, change_package: HealthComponent.ChangePackage, args: Dictionary)

var active := true

func _ready() -> void:
	hit.connect(func(n, cp: HealthComponent.ChangePackage, args: Dictionary):
		var h_comp: HealthComponent = get_node("%HealthComponent")
		if h_comp == null or !active:
			return
		h_comp.apply(cp)
		if owner.has_method(&"damage"):
			owner.call(&"damage", n, cp.amount, args)
	)
