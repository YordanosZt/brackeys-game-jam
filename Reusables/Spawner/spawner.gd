extends Node3D

@export var spawn_rate: float = 1.0
@export var spawn_pts: Array[Marker3D]
@export var spawn_item: PackedScene

@export var spawn_width: float

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = 1 / spawn_rate

func spawn() -> void:
	var _item = spawn_item.instantiate()
	var rand_pt = spawn_pts[randi_range(0, spawn_pts.size() - 1)]
	var rand_mult = -1 if randf() < 0.5 else 1
	
	_item.position = rand_pt.position
	_item.position.x += rand_mult * randf_range(0, spawn_width) / 2
	_item.rotation = rand_pt.rotation
	add_child(_item)

func _on_timer_timeout() -> void:
	spawn()
