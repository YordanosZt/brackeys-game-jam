extends Node3D

@export var max_time: float = 100.0
@onready var current_time: float = max_time
@onready var time_bar: ProgressBar = %TimeBar

func _ready() -> void:
	time_bar.value = (current_time / max_time) * 100.0

func _process(delta: float) -> void:
	handle_restart()
	
	if current_time > 0:
		handle_time_pressure(delta)

func handle_restart() -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func handle_time_pressure(delta) -> void:
	current_time -= delta
	time_bar.value = (current_time / max_time) * 100.0
