extends Node2D

var separation = 5000
var Stage 
var Player1
# Called when the node enters the scene tree for the first time.
func _ready():
	Stage = self.get_children()[0]
	Player1 = self.get_children()[1]
	Player1.move(Vector2(-separation, 0) + Stage.position * 100)
	curr_frame(Player1).visible = true

var p1_velocity = Vector2i(0, 0)
var direction: int
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_physics_phase()
	direction = int(Input.is_action_pressed("right")) * 1 + int(Input.is_action_pressed("left")) * -1 + int(Input.is_action_pressed("down")) * -3 + int(Input.is_action_pressed("up")) * 3 + 5
	do_action_phase()

func do_physics_phase():
		#Friction
	if Player1.is_grounded:
		if not Player1.has_traction:
			p1_velocity.x = p1_velocity.x*99/100
		else:
			p1_velocity = Vector2i(0, 0)
		if not Player1.has_traction and p1_velocity == Vector2i(0, 0):
			Player1.has_traction = true
	
	#Gravity
	if not Player1.is_grounded:
		p1_velocity.y += 45
	
	#Summing
	if Player1.is_grounded and Player1.has_traction:
		match direction:
			1, 2, 3, 5:
				p1_velocity = Vector2i(0, 0)
			6:
				p1_velocity = Vector2i(400, 0)
			4:
				p1_velocity = Vector2i(-400, 0)
			7:
				p1_velocity = Vector2i(-400, -1500)
				Player1.is_grounded = false
			8:
				p1_velocity = Vector2i(0, -1500)
				Player1.is_grounded = false
			9:
				p1_velocity = Vector2i(400, -1500)
				Player1.is_grounded = false
	
	elif Player1.is_grounded:
		match direction:
			6:
				p1_velocity.x = min(p1_velocity.x + 20, 150)
			4:
				p1_velocity.x = max(p1_velocity.x - 20, -150)
			8:
				p1_velocity.y += -500
				Player1.is_grounded = false
	
	#Limiting
	if Player1.int_position.x + Player1.pushbox.size.x/2 + p1_velocity.x > Stage.position.x * 100 + Stage.width:
		p1_velocity.x = -Player1.int_position.x - Player1.pushbox.size.x/2 + (Stage.position.x * 100 + Stage.width)
	elif Player1.int_position.x - Player1.pushbox.size.x/2 + p1_velocity.x < Stage.position.x * 100 - Stage.width:
		p1_velocity.x = Player1.pushbox.size.x/2 - Player1.int_position.x + (Stage.position.x * 100 - Stage.width)
	if Player1.int_position.y + p1_velocity.y >= Stage.position.y * 100 and not Player1.is_grounded:
		var old_y_velocity = p1_velocity.y
		p1_velocity.y = 0
		Player1.is_grounded = true
	
	match (Player1.is_grounded):
		true:
			Player1.displace(Vector2i(p1_velocity.x, 0))
			Player1.move(Vector2i(Player1.int_position.x, Stage.position.y * 100))
		false:
			Player1.displace(p1_velocity)


func do_action_phase():
	#Cancel has occured
	if (direction == 6):
		if Player1.CurrentAction != Player1.get_node("WalkForward"):
			curr_frame(Player1).visible = false
			Player1.CurrentAction = Player1.get_node("WalkForward")
			Player1.frame_number = 0
			Player1.frame_age = 0
			curr_frame(Player1).visible = true
			return
	elif Player1.CurrentAction == Player1.get_node("WalkForward") and Player1.frame_number < 12:
		curr_frame(Player1).visible = false
		Player1.frame_number = 12
		Player1.frame_age = 0
		curr_frame(Player1).visible = true
		return
	print(Player1.frame_number)
	#No cancel has occured
	#repeat frame
	var stay_frames: int = -1
	if (curr_frame(Player1).data.has("stay_frames")):
		stay_frames = curr_frame(Player1).data["stay_frames"]
	elif (Player1.CurrentAction.data.has("stay_frames")):
		stay_frames = Player1.CurrentAction.data["stay_frames"]
	if (stay_frames == -1):
		curr_frame(Player1).visible = false
		Player1.frame_number += 1
		curr_frame(Player1).visible = true
		return
	elif (stay_frames > Player1.frame_age):
		Player1.frame_age += 1
		return
	
	if Player1.CurrentAction.data.has("loop_frames"):
		if Player1.frame_number == Player1.CurrentAction.data["loop_frames"][1]:
			curr_frame(Player1).visible = false
			Player1.frame_number = Player1.CurrentAction.data["loop_frames"][0]
			curr_frame(Player1).visible = true
	
	#typical action followup
	if Player1.frame_number >= action_frames(Player1).size() - 1:
		curr_frame(Player1).visible = false
		Player1.CurrentAction = Player1.CurrentAction.relations["transition_action"]
		Player1.frame_number = 0
		Player1.frame_age = 0
		curr_frame(Player1).visible = true
	else:
		curr_frame(Player1).visible = false
		Player1.frame_number += 1
		Player1.frame_age = 0
		curr_frame(Player1).visible = true

func action_frames(player: Character) -> Array[Node]:
	return Player1.CurrentAction.get_children()


func curr_frame(character: Character) -> Frame:
	return action_frames(Player1)[Player1.frame_number]
