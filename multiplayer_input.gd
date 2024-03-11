extends Node


var device_ports: Array[int] = [0, -1, -1, -1, -1, -1, -1, -1, 1]

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

var counter: int = 0
func _process(_delta):
	if counter >= 10:
		print(port_inputs[0])
		counter = -1
	counter += 1


func _device_id(event: InputEvent) -> int:
	if event is InputEventKey:
		return 8
	else:
		return event.device
