extends Area3D

@export var max_health: float = 100.0
@onready var current_health: float = max_health

@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

var equipped: bool = false

func _ready() -> void:
	health_bar.value = (current_health / max_health) * 100.0

func set_parent(parent: Node3D) -> void:
	reparent(parent, false)

func equip() -> void:
	equipped = true
	health_bar.visible = true

func take_damage(amount: float) -> void:
	current_health -= amount
	
	health_bar.value = (current_health / max_health) * 100.0
	
	if current_health <= 0:
		print("Item is Gone!")
		queue_free()
