extends Node
class_name CardMovementComponent

enum MOVEMENT_TYPE {LINEAR, LERP, BOUNCE}
@export var current_movement_type: MOVEMENT_TYPE
@export var movement_speed: float = 1.0
@export var lerp_mult: float = 1.0
