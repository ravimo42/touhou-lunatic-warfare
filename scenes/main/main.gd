class_name App extends Node

static var data := {
	"name": ProjectSettings.get_setting("application/config/name"),
	"description": ProjectSettings.get_setting("application/config/description"),
	"version": ProjectSettings.get_setting("application/config/version"),
	"platform": OS.get_name(),
	"debug_build": OS.is_debug_build()
}

@export var next_scene: PackedScene = load("res://scenes/game/game.tscn")

func _ready() -> void:
	SceneManager.change_scene.call_deferred(next_scene, true)
