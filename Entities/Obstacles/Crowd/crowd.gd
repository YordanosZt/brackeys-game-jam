extends Area3D

var rand_freq: Array[float]
var rand_amp: Array[float]

var crowd_count: int
var time: float = 0.0

@onready var meshes: Node3D = $Meshes

func _ready():
	crowd_count = meshes.get_child_count()
	
	for i in crowd_count:
		rand_freq.append(randf_range(10.0, 20.0))
		rand_amp.append(randf_range(0.1, 0.5))

func _process(delta: float) -> void:
	for i in crowd_count:
		meshes.get_child(i).global_position.y = 1.8 + rand_amp[i] * sin(time * rand_freq[i])
	
	time += delta
