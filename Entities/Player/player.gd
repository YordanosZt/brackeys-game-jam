extends CharacterBody3D

@export var move_speed: float = 500.0

var input_dir: Vector2
var direction: Vector2

@onready var visuals: Node3D = %Visuals

var isometric_up: Vector2 = Vector2(1, 1).normalized()
var isometric_right: Vector2 = Vector2(1, -1).normalized()

func _process(delta: float) -> void:
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
		velocity.x = direction.x * move_speed * delta
		velocity.z = direction.y * move_speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)

func look() -> void:
	if direction:
		visuals.look_at(global_position - Vector3(direction.x, 0, direction.y))
		visuals.rotation.x = 0
