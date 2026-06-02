extends InputComponent
class_name PlayerInputComponent

@export var input_names: InputMapNames = InputMapNames.new()

func _input(event: InputEvent) -> void:
	if event.is_action_type():
		var _in = input_names
		
		if event.is_action_pressed(_in.attack):
			attack_input.emit()
			
		elif event.is_action_pressed(_in.jump):
			jump_input.emit(true)
		elif event.is_action_released(_in.jump):
			jump_input.emit(false)
			
		elif event.is_action_released(_in.aim):
			aim_input.emit(true)
		elif event.is_action_released(_in.aim):
			aim_input.emit(false)
			
		elif event.is_action_released(_in.crouch):
			crouch_input.emit(true)
		elif event.is_action_released(_in.aim):
			crouch_input.emit(false)
			
		else:
			for i in range(len(_in.abilities)):
				if event.is_action_pressed(_in.abilities[i]):
					ability_input.emit(i)

func _process(delta: float) -> void:
	movement_direction.x = Input.get_axis(input_names.move_left, input_names.move_right)
	movement_direction.y = Input.get_axis(input_names.move_up, input_names.move_down)
	
