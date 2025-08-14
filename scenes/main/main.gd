extends Node

@export var next_scene: PackedScene = load("res://scenes/game/game.tscn")

func _ready() -> void:
	SceneManager.change_scene.call_deferred(next_scene, true)
