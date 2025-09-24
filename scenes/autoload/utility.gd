extends Node


func has_nested_key(dict: Dictionary, nested_keys: Array):
	var currentValue = dict
	
	for key in nested_keys:
		if currentValue.has(key):
			currentValue = currentValue[key]
		else:
			return false
	
	return true


func get_nested(dict: Dictionary, default, nested_keys: Array):
	var currentValue = dict
	var debug_message = "Valid keys: "
	
	for key in nested_keys:
		if currentValue.has(key):
			currentValue = currentValue[key]
			debug_message += str(key)
		else:
			return default
	
	print(debug_message)
	return currentValue
