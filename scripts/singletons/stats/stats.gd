extends Node

signal stats_changed(which: StringName, what: StringName, value: Variant)
signal stats_notification(what: StringName, value: Variant)
signal spell_card(what: StringName, value: Variant)

var _stats := {
	&"player_health": {
		&"value": 100.0,
		&"max_value": 100.0
	},
	&"hover": {
		&"value": 100.0,
		&"max_value": 100.0
	},
	&"power": {
		&"value": 100,
		&"max_value": 100
	},
	&"dash": {
		&"value": 100,
		&"max_value": 100
	},
}

func send_notification(what: StringName, value: Variant = null) -> void:
	stats_notification.emit(what, value)

func activate_spellcard(what: StringName, value: Variant = null) -> void:
	spell_card.emit(what, value)

func set_stats(which: StringName, what: StringName, value: Variant) -> void:
	_stats[which][what] = value
	stats_changed.emit(which, what, value)

func get_stats(which: StringName, what: StringName) -> Variant:
	return _stats[which][what]
