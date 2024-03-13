class_name Collider extends Resource


@export var rects: Array[Rect2i] = []
@export var position: Vector2i = Vector2i(0, 0)


func is_colliding(OtherCollider: Collider) -> bool:
	for rect in self.rects:
		for other_rect in OtherCollider.rects:
			rect.size += Vector2i(1, 1)
			rect.position += self.position - Vector2i(1, 1)
			other_rect.size += Vector2i(1, 1)
			other_rect.position += OtherCollider.position - Vector2i(1, 1)
			if rect.intersects(other_rect):
				return true
	return false
