extends Area3D


func set_parent(parent: Node3D) -> void:
	reparent(parent, false)
