extends CharacterBody2D
class_name EntityTemplate

@export var physics_component: PhysicsComponent
@export var input_component: InputComponent

var acceleration: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	physics_component.handle_physics(delta)
