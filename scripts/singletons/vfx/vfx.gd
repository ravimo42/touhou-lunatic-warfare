extends Node

var scenes := {
	"explosion1": load("uid://c4ggga87ktx3r")
}

class Explosion:
	func _init(node: Node2D) -> void:
		var ex: AnimatedSprite2D = VFX.scenes.explosion1.instantiate()
		Arena.other_nodes.add_child(ex)
		ex.global_position = node.global_position
