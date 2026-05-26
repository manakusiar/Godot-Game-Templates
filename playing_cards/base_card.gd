extends Node2D

@export var variables: Dictionary[String, CardVariable]

func _ready() -> void:
	for key in variables:
		_update_vkey(key)

func _update_vkey(key: String):
	var _v = variables[key]
	var _value = _v.value
	
	for path in _v.nodes:
		var _node = get_node(path)
		if _node is Label:
			_node.text = _value
