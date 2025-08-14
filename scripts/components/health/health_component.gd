class_name HealthComponent extends Node2D

signal changed(res: Result)
signal died

@export var max_health: int = 100
@export var health: int = 100:
	set(val): health = clampi(val, 0, max_health)

## Make a new ChangePackage to deliver
static func new_package() -> ChangePackage:
	return ChangePackage.new()

class ChangePackage:
	var amount := 0
	var damage: int:
		get: return maxi(0, - amount)
		set(val): amount = - maxi(0, val)
	var heal: int:
		get: return maxi(0, amount)
		set(val): amount = maxi(0, val)

class Result:
	var actual_amount := 0
	var amount := 0
	var killed := false
	var change_package: ChangePackage

var percent: float:
	get: return float(health)/max_health
	set(v): health = ceili(max_health * v)
var is_dead := false

## Apply package into this HealthComponent
func apply(change: ChangePackage) -> Result:
	var res = Result.new()
	res.change_package = change
	if is_dead:
		changed.emit(res)
		return res
	var old := health
	health += change.amount
	
	res.actual_amount = health - old
	res.amount = health
	if change.damage > 0 and health == 0:
		res.killed = true
		is_dead = true
		died.emit()
		if owner.has_method(&"die"):
			owner.call(&"die")
	changed.emit(res)
	return res

## Retreive health in formatted string 'health/max_health'
func get_info_string()->String:
	return "%d/%d" % [health, max_health]
	
func _write_data(data:Dictionary):
	data.health = health

func _read_data(data:Dictionary):
	health = data.health
