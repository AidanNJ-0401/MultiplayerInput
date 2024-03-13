extends Node2D

#half the stage's width
@export var width: int
@export var floor_elevation: int = position.x


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_line(Vector2(-self.width, 0),
			Vector2(self.width, 0), Color(Color.RED))
