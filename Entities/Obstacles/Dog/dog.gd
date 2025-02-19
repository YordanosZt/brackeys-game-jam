extends Node3D

var speed: float = 0.1

@export var path: PathFollow3D

@onready var move_pivot: Marker3D = $MovePivot

func _process(delta: float) -> void:
	path.progress_ratio += speed * delta
	if path.progress_ratio == 1: path.progress_ratio = 0
	
	move_pivot.position = lerp(move_pivot.position, path.position, 10 * delta)
	
