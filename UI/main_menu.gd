extends CanvasLayer

@export var first_scene: PackedScene

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func change_scene() -> void:
	get_tree().change_scene_to_packed(first_scene)

func _on_start_btn_pressed() -> void:
	if first_scene:
		animation_player.play("fadein")
	else:
		print("First scene was not assigned!")


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
