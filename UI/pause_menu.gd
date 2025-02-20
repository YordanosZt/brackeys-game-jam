extends Control

var is_paused: bool = false

func _ready() -> void:
	visible = is_paused

func _process(delta: float) -> void:
	handle_pause()

func handle_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		Engine.time_scale = 0 if is_paused else 1
		visible = is_paused


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
