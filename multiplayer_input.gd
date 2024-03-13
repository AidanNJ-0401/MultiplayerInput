extends Node


var device_ports: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1]

var inputs: Dictionary = {
	"up" : false,
	"down" : false,
	"left" : false,
	"right" : false,
	"a" : false,
	"b" : false,
	"x" : false,
	"y" : false,
	"l1" : false,
	"r1" : false,
	"l2" : false,
	"r2" : false,
	"select" : false,
	"start" : false,
	"l3" : 0.0,
	"r3" : 0.0,
	"left_stick" : Vector2(0.0, 0.0),
	"right_stick" : Vector2(0.0, 0.0),
	"home" : false,
	"share" : false,
	"p1" : false,
	"p2" : false,
	"p3" : false,
	"p4" : false
}

var port_inputs: Array[Dictionary] = [
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate(),
	inputs.duplicate()	
]

func _input(event):
	var device: int = _device_id(event)
	if device_ports[device] == -1:
		return
	var is_action: bool = false
	var action: StringName
	for map_action in InputMap.get_actions():
		if event.is_action(map_action):
			is_action = true
			action = map_action
	if not is_action:
		return
	if event is InputEventJoypadButton or event is InputEventKey:
		if event.is_pressed():
			port_inputs[device_ports[device]][action] = true
		if event.is_released():
			port_inputs[device_ports[device]][action] = false
		return
	if event is InputEventJoypadMotion:
		if action == "left_stick_left" or action == "left_stick_right":
			port_inputs[device_ports[device]]["left_stick"].x = event.axis_value
		elif action == "left_stick_up" or action == "left_stick_down":
			port_inputs[device_ports[device]]["left_stick"].y = event.axis_value
		elif action == "right_stick_left" or action == "right_stick_right":
			port_inputs[device_ports[device]]["right_stick"].x = event.axis_value
		elif action == "right_stick_up" or action == "right_stick_down":
			port_inputs[device_ports[device]]["right_stick"].y = event.axis_value
		else:
			port_inputs[device_ports[device]][action] = event.axis_value


func _process(_delta):
	pass


func port_in_range(port: int) -> bool:
	return port < device_ports.size() and port >= 0


func device_in_range(device: int) -> bool:
	return device <= 8 and device >= 0


func _device_id(event: InputEvent) -> int:
	if event is InputEventKey:
		return 8
	else:
		return event.device





func disconnect_device(device: int):
	pass


class Device:
	var id: int
	pass


## Connects devices to ports. Holds inputs to be sent via a group.
class Ports extends Node:
	var device_ports: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1]
	var port_to_device_info: Dictionary = {
		0 : { },
		1 : { },
		2 : { },
		3 : { },
		4 : { },
		5 : { },
		6 : { },
		7 : { },
		8 : { }
	}
	
	
	func port_in_range(port: int) -> bool:
		return port < device_ports.size() and port >= 0
	pass
	
	
	func connect_device(device: int, port: int):
		if (port_in_range(port)
				or device > 8 or device < 0):
			return ERR_PARAMETER_RANGE_ERROR
		
		device_ports[device] = port
		port_to_device_info[port] = get_device_info(device)
		
		return OK
	
	func get_device_info(device: int) -> Dictionary:
		if device == 8:
			return { "keyboard": null }
		else:
			return Input.get_joy_info(device)
