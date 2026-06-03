extends Node2D
class_name PhysicsComponent

@export_subgroup("Nodes")
@export var LocalInputComponent: InputComponent
@export var target: EntityTemplate

@export_subgroup("Settings/Toggles")
@export var use_acceleration := true
@export var use_acceleration_movement := false # Use acceleration based left-right movement
@export var use_acceleration_jumping := true # Use acceleration based jumping
@export var use_cayote_timing := true
@export var use_short_jumps := true # Be able to cancel jump by letting go of the button  

@export_subgroup("Settings/Values")
@export var movement_speed: float = 128.0
@export var jump_height: float = 140.0
@export var distance_to_jump_height: float = 128
@export var air_movement_mutliplier: Vector2 = Vector2(0.50, 0.25)
@export var resistence: Vector2 = Vector2(0.8, 1)
@export var max_speed: Vector2 = Vector2(64*8, 10000)
@export var fall_gravity_multiplier: float = 1.0

# Nodes
var cayote_timer: Timer
var target_was_on_floor: bool = false

var jump_buffer_timer: Timer

var gravity: float = 0.0
var jump_power: float = 0.0
var is_falling: bool = false

var test_pos := Vector2.ZERO

# --- Engine Callback ---

func _ready() -> void:
	var _lic: InputComponent = LocalInputComponent
	_lic.jump_input.connect(_jump_input)
	_lic.aim_input.connect(_aim_input)
	_lic.crouch_input.connect(_crouch_input)
	
	_update_jump_vriables()
	_setup_timers()

# ---------------
# --- Physics ---
# ---------------

func handle_physics(delta: float) -> void:
	var _dmult := delta * 60
	
	_handle_jumping()
	_handle_gravity(_dmult)
	_handle_movement(_dmult)
	
	var _previous_position = target.position
	
	_apply_physics()
	
	_handle_peak_of_jump(_previous_position)

# JUMPING
func _handle_jumping() -> void:
	var _is_on_floor = target.is_on_floor()
	
	# Starting cayote timer
	if target_was_on_floor != _is_on_floor:
		cayote_timer.start()
		target_was_on_floor = _is_on_floor
	
	# Jump check
	var _can_jump = _is_on_floor or not cayote_timer.is_stopped()
	var _should_jump = not jump_buffer_timer.is_stopped()
	if _should_jump and _can_jump:
			jump()
			jump_buffer_timer.stop()

# PEAK OF JUMP
func _handle_peak_of_jump(_previous_position) -> void:
	# Check for peak of jump
	if _previous_position.y < target.position.y and is_falling == false:
		#print((test_pos - _previous_position).abs()) # Print jump distance till peak
		is_falling = true

# GRAVITY 
func _handle_gravity(dmult: float) -> void:
	var _gravity = gravity * dmult
	
	# Multiply gravity after peak of jump
	if is_falling:
		_gravity *= fall_gravity_multiplier
	
	target.velocity.y -= _gravity

# HORIZONTAL MOVEMENT
func _handle_movement(dmult: float) -> void:
	var _is_on_floor = target.is_on_floor()
	var move_dir := LocalInputComponent.get_movement_input()
	var _movement_speed = movement_speed * move_dir.x * dmult
	
	if _is_on_floor:
		# Floor resitence
		target.velocity *= resistence
	else:
		# Reduce movement in air
		_movement_speed *= air_movement_mutliplier.x
	
	target.velocity.x += _movement_speed

# APPLY MOVEMENT
func _apply_physics() -> void:
	# Limit velocity
	target.velocity = target.velocity.clamp(-max_speed, max_speed)
	
	# Apply movement
	target.move_and_slide()

# -----------------------------
# --- Input Signal Callback ---
# -----------------------------

func _jump_input(is_button_held: bool) -> void:
	if is_button_held:
		jump_buffer_timer.start()
	elif is_falling == false:
		target.velocity.y *= 0.5

func _aim_input(is_button_held: bool) -> void:
	pass

func _crouch_input(is_button_held: bool) -> void:
	pass

# ------------------------
# --- Helper Functions ---
# ------------------------

# JUMP FUNCTION
func jump() -> void:
	test_pos = target.position
	is_falling = false
	target.velocity.y = -jump_power

# CALCULATE JUMP VARIABLES
func _update_jump_vriables() -> void:
	# Calculate the gravity and jump power depending on jump distance and jump height
	var _ticks_to_jump_height = distance_to_jump_height / max_speed.x * 60 # Time to reach peak of jump (ticks)
	var final_jump_height = jump_height * 1.05  # Little addon to make sure you always reach just above the height
	gravity = -2*final_jump_height / (_ticks_to_jump_height**2 / 60)
	jump_power = (2*final_jump_height) / (_ticks_to_jump_height / 60)

# CREATE / RESTORE TIMERS
func _setup_timers() -> void:
	# Free old timers
	var _timers: Array[Timer] = [cayote_timer, jump_buffer_timer]
	for _timer in _timers:
		if _timer != null: _timer.queue_free()
	
	# Cayote timer
	cayote_timer = Timer.new()
	cayote_timer.one_shot = true
	cayote_timer.wait_time = 0.05
	add_child(cayote_timer)
	
	# Jump buffer timer
	jump_buffer_timer = Timer.new()
	cayote_timer.one_shot = true
	jump_buffer_timer.wait_time = 0.3
	add_child(jump_buffer_timer)
