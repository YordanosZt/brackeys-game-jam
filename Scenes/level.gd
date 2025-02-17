extends Node3D

@onready var pause_menu: PanelContainer = %PauseMenu
var is_paused: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		Engine.time_scale = 0 if is_paused else 1
		pause_menu.visible = is_paused
