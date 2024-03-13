extends Node


var c1 = Collider.new()
var c2 = Collider.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	c1.rects.assign(Array([Rect2i(100, 100, 100, 100), Rect2i(400, 100, 100, 100)]))
	c2.rects.assign(Array([Rect2i(300, 100, 100, 100)]))
	print(c1.is_colliding(c2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
