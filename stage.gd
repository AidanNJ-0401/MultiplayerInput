extends Node2D

#half the stage's width
@export var width: int = 56000
@export var floor_elevation: int = 37000


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	#draw_line(Vector2(-self.width, 0),
			#Vector2(self.width, 0), Color(Color.RED))
	draw_multiline(PackedVector2Array([Vector2(-self.width/100.0 - 1, -1000), Vector2(-self.width/100.0 - 1, 1), Vector2(-self.width/100.0 - 1, 1),
			Vector2(self.width/100.0 + 1, 1), Vector2(self.width/100.0 + 1, 1), Vector2(self.width/100.0 + 1, -1000)]), Color(Color.RED))
