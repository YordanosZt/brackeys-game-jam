extends Node3D

var is_paused: bool = false
@onready var pause_menu: PanelContainer = %PauseMenu

@export var max_time: float = 100.0
@onready var current_time: float = max_time
@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	time_label.text = "Time: " + str(int(current_time * 100) / 100.0)

func _process(delta: float) -> void:
	handle_pause()
	
	handle_time_pressure(delta)

func handle_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		Engine.time_scale = 0 if is_paused else 1
		pause_menu.visible = is_paused

func handle_time_pressure(delta) -> void:
	current_time -= delta
	time_label.text = "Time: " + str(int(current_time * 100) / 100.0)
	
	if current_time <= 0:
		time_label.text = str("You Lost!")
