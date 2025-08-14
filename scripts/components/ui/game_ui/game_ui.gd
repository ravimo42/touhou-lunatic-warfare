class_name GameUI extends MarginContainer

static var instance: GameUI

@onready var _hover_stats := %HoverStats
@onready var _dash_stats := %DashStats

func _init() -> void:
	instance = self

func _ready() -> void:
	_connect_signal()
	%PName.text = App.data.name_localized["ja_JP"]
	%PVersion.text = App.data.version

func _connect_signal() -> void:
	Stats.stats_changed.connect(func(which: StringName, what: StringName, value: Variant):
		if which == &"hover":
			var max_val: float = Stats.get_stats(&"hover", &"max_value")
			_hover_stats.value = remap(value, 0.0, max_val, 0.0, 100.0)
		if which == &"dash":
			_dash_stats.value = Stats.get_stats(&"dash", what)
	)
	Stats.stats_notification.connect(func(what: StringName, _value: Variant):
		if what == &"hover_full":
			AutoTween.new(_hover_stats, &"modulate", Color.WHITE, 1.5).from(Color(10.0,10.0,10.0))
		if what == &"hover_depleted":
			AutoTween.new(_hover_stats, &"modulate:r", 1.0, 1.5).from(10.0)
	)
