class_name Character extends Node2D


@export var char_name:String
@export var pushbox: Rect2i = Rect2i(-128, -128, 128, 128)
@export var CurrentAction: Action
var frame_number: int = 0
var frame_age: int = 0
var is_grounded: bool = false
var has_traction: bool = false

var int_position: Vector2i = Vector2i(0, 0)
var global_int_position: Vector2i = Vector2i(0, 0)
## last integer value 32 bit float can represent without rounding,
## both positively and negatively
var MAX_POSITION: int = 16777216


# Called when the node enters the scene tree for the first time.
func _ready():
	var Idle = get_node("Idle")
	Idle.relations["transition_action"] = Idle
	Idle.data["stay_frames"] = 5
	var WalkF = get_node("WalkForward")
	WalkF.relations["transition_action"] = Idle
	WalkF.data["stay_frames"] = 5
	WalkF.data["loop_frames"] = [3, 10]


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
	self.int_position = p_position
	self.position = int_position/100.0


func global_move(p_position: Vector2i):
	if (not is_valid_position(p_position)):
		return FAILED
	self.global_int_position = p_position
	self.global_position = self.global_int_position/100.0


func is_valid_position(p_position: Vector2i) -> bool:
	return (abs(p_position.x) <= MAX_POSITION
			or abs(p_position.y) <= MAX_POSITION)
