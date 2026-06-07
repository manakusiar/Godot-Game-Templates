extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = (get_tree().paused == false)
		print("hello")
