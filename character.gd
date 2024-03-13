class_name Character extends Node2D


@export var actions: Array[Action]

var int_position: Vector2i
## last integer value 32 bit float can represent without rounding,
## both positively and negatively
var MAX_POSITION: int = 16777216


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func displace(displacement: Vector2i):
	if (not is_valid_position(int_position + displacement)):
		return FAILED
	move(int_position + displacement)
	pass


func move(p_position: Vector2i):
	if (not is_valid_position(p_position)):
		return FAILED
	self.position = p_position


func is_valid_position(p_position: Vector2i) -> bool:
	return (abs(p_position) <= MAX_POSITION
			or abs(p_position) <= MAX_POSITION)
