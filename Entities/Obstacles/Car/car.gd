extends Node3D

var speed: float = 10.0

func _process(delta: float) -> void:
	var move_vec = transform.basis.z * speed * delta
	
	global_translate(move_vec)
