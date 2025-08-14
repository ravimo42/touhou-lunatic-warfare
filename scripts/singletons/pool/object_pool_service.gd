extends Node

var default_parent: Node:
	get:
		if Arena.instance != null:
			return Arena.pooled_nodes
		return get_tree().current_scene
var pools := {}

func get_pool(template: PackedScene, node_parent: Node = null) -> ObjectPool:
	if pools.has(template):
		return pools[template]
	if node_parent == null:
		node_parent = default_parent
	var pool := ObjectPool.new(template, node_parent)
	pools[template] = pool
	if node_parent != null and !node_parent.tree_exiting.is_connected(_node_parent_exiting_tree):
		node_parent.tree_exiting.connect(_node_parent_exiting_tree.bind(template))
	return pool

func clear_all():
	for template in pools:
		var pool :ObjectPool = pools[template]
		pool.clear()
	pools.clear()

func get_pool_from_object(obj: Node)-> ObjectPool:
	if !obj.has_meta(&"object_pool"):
		return null
	return obj.get_meta(&"object_pool")

func unclaim(obj: Node):
	var pool := get_pool_from_object(obj)
	assert(pool != null, "Object does not belong to a pool")
	pool.unclaim(obj)

func _node_parent_exiting_tree(template:PackedScene):
	var pool :ObjectPool = pools[template]
	pools.erase(template)
	pool.clear()
