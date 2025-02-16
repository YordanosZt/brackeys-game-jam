extends CharacterBody3D

@export var move_speed: float = 500.0

var input_dir: Vector2
var direction: Vector3

@onready var visuals: Node3D = %Visuals

func _process(delta: float) -> void:
	handle_input()

func _physics_process(delta: float) -> void:
	move(delta)
	look()
	
	move_and_slide()

func handle_input() -> void:
	var hor_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var ver_input: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	input_dir = Vector2(hor_input, ver_input).normalized()
	
	var angle: float = 15.0
	var new_dir: Vector2
	new_dir.x = cos(angle) * input_dir.x - sin(angle) * input_dir.y
	new_dir.y = sin(angle) * input_dir.x + cos(angle) * input_dir.y
	
	input_dir = -new_dir
	
	#input_dir = Input.get_vector("left", "right", "up", "down")

func move(delta) -> void:
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed * delta
		velocity.z = direction.z * move_speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * delta)

func look() -> void:
	if direction:
		visuals.look_at(global_position - direction)
		visuals.rotation.x = 0
