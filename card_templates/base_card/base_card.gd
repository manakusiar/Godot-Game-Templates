extends Control

@export var variables: Dictionary[String, CardVariable]

func _ready() -> void:
	for key in variables:
		_update_vkey(key)

func _update_vkey(key: String):
	var _v = variables[key]
	var _value = _v.value
	
	for path in _v.nodes:
		var _node = get_node(path)
		if "text" in _node:
			_node.text = _value
		if "texture" in _node and _value.get_extension() in ["png", "jpg"]:
			_node.texture = load(_value)
		print("texture" in _node, _node.name)

func set_variable(variable_name: String, new_value: String) -> void:
	if variable_name in variables:
		variables[variable_name].value = new_value
