extends Node
class_name InputComponent

signal attack_input
signal jump_input
signal crouch_input
signal aim_input
signal ability_input

var movement_direction = Vector2.ZERO

func get_movement_input() -> Vector2:
	return movement_direction

func get_angle_to_mouse(pos: Vector2) -> float:
	return pos.angle_to_point(get_viewport().get_mouse_position())
