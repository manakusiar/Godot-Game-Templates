extends Node2D
class_name PhysicsComponent

@export_subgroup("Nodes")
@export var LocalInputComponent: InputComponent
@export var target: EntityTemplate
@export_subgroup("Settings/Toggles")
@export var use_acceleration := true
@export var use_acceleration_movement := true # Use acceleration based left-right movement
@export var use_acceleration_jumping := true # Use acceleration based jumping
@export var use_cayote_timing := true
@export var use_short_jumps := true # Be able to cancel jump by letting go of the button  
@export_subgroup("Settings/Values")
@export var movement_speed: float = 40.0
@export var jump_height: float = 250.0
@export var gravity_acceleration: float = 5.0
@export var gravity_velocity: float = 40.0
@export var resistence: Vector2 = Vector2(0.8, 0.9)
@export var max_speed: Vector2 = Vector2(70, 600)

var acceleration_modifier := Vector2(1.0, 1.0)

func _ready() -> void:
	var _lic: InputComponent = LocalInputComponent
	_lic.jump_input.connect(_jump_input)
	_lic.aim_input.connect(_aim_input)
	_lic.crouch_input.connect(_crouch_input)

func handle_physics(delta: float) -> void:
	var dmult := delta * 60
	var move_dir := LocalInputComponent.get_movement_input()
	var acc: Vector2 = target.acceleration
	var vel: Vector2 = target.velocity
	
	if use_acceleration_movement:
		acc.x += movement_speed * move_dir.x * dmult
	else:
		vel.x += movement_speed * move_dir.x * dmult
	
	if use_acceleration and use_acceleration_jumping:
		acc.y += gravity_acceleration * dmult
		vel .y += gravity_velocity * dmult
	else:
		vel.y += gravity_velocity * dmult
	
	if target.is_on_ceiling() and acc.y < 0:
		acc.y = 0
	if target.is_on_floor() and acc.y > 0:
		acc.y = 0
	
	vel += acc * dmult
	vel *= resistence * dmult
	acc *= resistence * dmult
	acc.x = min(acc.x, max_speed.x) if acc.x > 0 else max(acc.x, -max_speed.x)
	acc.y = min(acc.y, max_speed.y) if acc.y > 0 else max(acc.y, -max_speed.y)
	
	target.velocity = vel
	target.acceleration = acc
	target.move_and_slide()

func _jump_input(is_button_held: bool) -> void:
	if is_button_held and target.is_on_floor():
		target.acceleration.y -= jump_height
	elif target.acceleration.y < 0 :
		target.acceleration.y = 0

func _aim_input(is_button_held: bool) -> void:
	pass

func _crouch_input(is_button_held: bool) -> void:
	pass
