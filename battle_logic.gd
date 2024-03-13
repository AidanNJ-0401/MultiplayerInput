extends Node2D

var separation = 5000
var Stage 
var Player1
# Called when the node enters the scene tree for the first time.
func _ready():
	Stage = self.get_children()[0]
	Player1 = self.get_children()[1]
	Player1.move(Vector2(-separation, 0) + Stage.position * 100)

var p1_velocity = Vector2i(0, 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Resistance
	if Player1.is_grounded:
		p1_velocity.x = p1_velocity.x*99/100
		if p1_velocity == Vector2i(0, 0):
			Player1.has_traction = true
	p1_velocity.y += 7
	var direction = int(Input.is_action_pressed("right")) * 1 + int(Input.is_action_pressed("left")) * -1 + int(Input.is_action_pressed("down")) * -3 + int(Input.is_action_pressed("up")) * 3 + 5
	#Summing
	if Player1.is_grounded and Player1.has_traction:
		match direction:
			5:
				p1_velocity = Vector2i(0, 0)
			6:
				p1_velocity = Vector2i(150, 0)
			4:
				p1_velocity = Vector2i(-150, 0)
			7:
				p1_velocity = Vector2i(-150, -500)
				Player1.is_grounded = false
			8:
				p1_velocity = Vector2i(0, -500)
				Player1.is_grounded = false
			9:
				p1_velocity = Vector2i(150, -500)
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
	if Player1.int_position.y + p1_velocity.y >= Stage.position.y * 100:
		p1_velocity.y = 0
		Player1.is_grounded = true
	print(p1_velocity)
	match (Player1.is_grounded):
		true:
			Player1.displace(Vector2i(p1_velocity.x, 0))
			Player1.move(Vector2i(Player1.int_position.x, Stage.position.y * 100))
		false:
			Player1.displace(p1_velocity)


#
