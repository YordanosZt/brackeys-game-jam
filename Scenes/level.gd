extends Node3D

var is_paused: bool = false
@onready var pause_menu: PanelContainer = %PauseMenu

@export var max_time: float = 100.0
@onready var current_time: float = max_time
@onready var time_bar: ProgressBar = %TimeBar

func _ready() -> void:
	time_bar.value = (current_time / max_time) * 100.0

func _process(delta: float) -> void:
	handle_pause()
	
	if current_time > 0:
		handle_time_pressure(delta)

func handle_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		Engine.time_scale = 0 if is_paused else 1
		pause_menu.visible = is_paused

func handle_time_pressure(delta) -> void:
	current_time -= delta
	time_bar.value = (current_time / max_time) * 100.0
