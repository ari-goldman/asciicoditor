extends Area2D

signal character_selected(symbol_index: int)

@onready var collision_shape_2d := $CollisionShape2D

const HORIZONTAL_CHARS: int = 26
const VERTICAL_CHARS: int = 15

func _on_ready() -> void:
	pass


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_pressed("draw"):
		Global.selected_index = position_to_index(self.to_local(event.position))
	if Input.is_action_pressed("secondary_draw"):
		Global.selected_secondary_index = position_to_index(self.to_local(event.position))
		

func position_to_index(local_pos: Vector2) -> int:
	var area_size: Vector2 = collision_shape_2d.shape.size
	var normalized: Vector2 = (area_size + 2 * local_pos) / area_size / 2
	return (int)(VERTICAL_CHARS * normalized.y) * HORIZONTAL_CHARS + (int)(HORIZONTAL_CHARS * normalized.x)

