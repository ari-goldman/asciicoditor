extends Node
class_name Logic

const PIXEL := preload("res://scenes/pixel.tscn")
@onready var grid := %Grid
@onready var grid_array: Array[Pixel] = []
@onready var selector := %Selector

func _on_ready() -> void:
	call_deferred("_setup_grid")
	
	Global.logic = self
	
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	selector.position = view_size / 2.0 + view_size * 2 * Vector2.DOWN

var tween: Tween
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("selector"):
		var view_size: Vector2 = get_viewport().get_visible_rect().size
		
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(selector, "position",  view_size / 2.0, 0.25) \
			.set_ease(Tween.EASE_OUT)  \
			.set_trans(Tween.TRANS_QUAD)
			
		for pixel: Pixel in grid.get_children():
			pixel.darken()
		
	if Input.is_action_just_released("selector"):
		var view_size: Vector2 = get_viewport().get_visible_rect().size
		
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(selector, "position", view_size / 2.0 + view_size * 2 * Vector2.DOWN, 0.25) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_QUAD)
			
		refresh_all()

func _setup_grid() -> void:
	for child: Node in grid.get_children():
		child.queue_free()
	
	var i: int = 0
	for x in range(0, 53):
		for y in range(0, 25):
			var instance: Pixel = PIXEL.instantiate()
			instance.position = Vector2(x * 6, y * 7)
			instance.grid_index = i
			grid.add_child(instance)
			grid_array.append(instance)
			i += 1

func prepare_save() -> void:
	for pixel: Pixel in grid_array:
		pixel.prepare_save()
		
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	selector.position = view_size / 2.0 + view_size * 2 * Vector2.DOWN
	
	
func refresh_all() -> void:
	for pixel: Pixel in grid_array:
			pixel.refresh_pixel()
