extends CharacterBody3D

var move_speed: float = 10.0
var acceleration: float = 10.0
var deceleration: float = 5.0

var random_effects_count: int = 3
var rand_effect_idx: int = 0
var has_effect: bool = false
var allow_effect: bool = true

var input_dir: Vector2
var direction: Vector2
var isometric_up: Vector2 = Vector2(1, 1).normalized()
var isometric_right: Vector2 = Vector2(1, -1).normalized()

@onready var rotate_pivot: Marker3D = %RotatePivot
@onready var item_pos: Marker3D = %ItemPos

@onready var effects_timer: Timer = $EffectsTimer
@onready var effect_delay_timer: Timer = $EffectDelayTimer

@onready var speed_label: Label = $CanvasLayer/VBoxContainer/SpeedLabel
@onready var random_effects_label: Label = $CanvasLayer/VBoxContainer/RandomEffectsLabel
@onready var effects_timer_label: Label = $CanvasLayer/VBoxContainer/EffectsTimerLabel
@onready var effect_delay_label: Label = $CanvasLayer/VBoxContainer/EffectDelayLabel

func _ready() -> void:
	effects_timer.start()

func _process(_delta: float) -> void:
	handle_input()
	if allow_effect:
		handle_random_effects()

func _physics_process(delta: float) -> void:
	move(delta)
	look()
	
	move_and_slide()

func handle_input() -> void:
	input_dir = Input.get_vector("left", "right", "up", "down")

func move(delta) -> void:
	direction = input_dir.x * isometric_right + input_dir.y * isometric_up
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.y * move_speed, acceleration * delta)
		
		rotate_pivot.rotation_degrees.x = move_toward(rotate_pivot.rotation_degrees.x, -15.0, 40.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
		
		rotate_pivot.rotation_degrees.x = move_toward(rotate_pivot.rotation_degrees.x, 0.0, 40.0 * delta)

	
	speed_label.text = "Speed: " + str(int(velocity.length() * 100) / 100.0)

func look() -> void:
	if direction:
		var rot: float = atan2(direction.x, direction.y)
		rotate_pivot.rotation.y = lerp_angle(rotate_pivot.rotation.y, rot, 0.1)

func choose_random_effect() -> void:
	rand_effect_idx = randi_range(0, random_effects_count - 1)

func handle_random_effects() -> void:
	random_effects_label.text = "Effects: None"
	effects_timer_label.text = "Effect in: " + str(int(effects_timer.time_left * 100) / 100.0)
	effect_delay_label.text = "Effect gone in: " + str(int(effect_delay_timer.time_left * 100) / 100.0)
	
	$CanvasLayer/VisionEffect.visible = false
	
	if not has_effect: return
	
	match rand_effect_idx:
		0: 
			invert_controls()
			random_effects_label.text = "Effects: Inverted Controls"
		1: 
			vision_effect()
			random_effects_label.text = "Effects: Vision Problem"
		2: 
			dash()
			random_effects_label.text = "Effects: Dash"

func invert_controls() -> void:
	input_dir *= -1

func vision_effect() -> void:
	$CanvasLayer/VisionEffect.visible = true

func dash() -> void:
	velocity *= 1.5
	await get_tree().create_timer(0.2).timeout
	velocity /= 1.5
	has_effect = false

func _on_item_detector_area_entered(area: Area3D) -> void:
	if item_pos.get_child_count() > 0: return
	
	area.set_parent(item_pos)
	area.equip()
	area.position = Vector3.ZERO


func _on_effects_timer_timeout() -> void:
	choose_random_effect()
	
	effect_delay_timer.start()
	has_effect = true

func _on_effect_delay_timer_timeout() -> void:
	effects_timer.start()
	has_effect = false

func _on_hurt_box_area_entered(area: Area3D) -> void:
	if item_pos.get_child_count() > 0:
		item_pos.get_child(0).take_damage(10.0)


func _on_puddle_detector_area_entered(area: Area3D) -> void:
	move_speed *= 2.0
	acceleration *= 3.0
	deceleration /= 3.0


func _on_puddle_detector_area_exited(area: Area3D) -> void:
	move_speed /= 2.0
	acceleration /= 3.0
	deceleration *= 3.0
