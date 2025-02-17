extends CharacterBody3D

@export var move_speed: float = 10.0
@export var acceleration: float = 10.0
@export var deceleration: float = 5.0

var input_dir: Vector2
var direction: Vector2
var isometric_up: Vector2 = Vector2(1, 1).normalized()
var isometric_right: Vector2 = Vector2(1, -1).normalized()

@onready var rotate_pivot: Marker3D = %RotatePivot
@onready var item_pos: Marker3D = %ItemPos

func _process(_delta: float) -> void:
	handle_input()

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
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	
	$CanvasLayer/SpeedLabel.text = "Speed: " + str(int(velocity.length() * 100) / 100.0)

func look() -> void:
	if direction:
		var rot: float = atan2(direction.x, direction.y)
		rotate_pivot.rotation.y = lerp_angle(rotate_pivot.rotation.y, rot, 0.1)

func _on_item_detector_area_entered(area: Area3D) -> void:
	if item_pos.get_child_count() > 0: return
	
	area.set_parent(item_pos)
	area.position = Vector3.ZERO
