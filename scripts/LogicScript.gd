extends Node

const PIXEL := preload("res://scenes/pixel.tscn")
@onready var grid := %Grid
@onready var selector := %Selector
@onready var darkener := $"../Darkener"

const BOUNDS := Vector2()

func _on_ready() -> void:
	call_deferred("setup_grid")
	
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	selector.position = view_size / 2.0 + view_size * 2 * Vector2.DOWN

var tween: Tween
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("selector"):
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		
		var view_size: Vector2 = get_viewport().get_visible_rect().size
		
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(selector, "position",  view_size / 2.0, 0.25) \
			.set_ease(Tween.EASE_OUT)  \
			.set_trans(Tween.TRANS_QUAD)
			
		for pixel: Pixel in grid.get_children():
			pixel.dark = true
		
	if Input.is_action_just_released("selector"):
		#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		
		var view_size: Vector2 = get_viewport().get_visible_rect().size
		
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(selector, "position", view_size / 2.0 + view_size * 2 * Vector2.DOWN, 0.25) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_QUAD)
			
		for pixel: Pixel in grid.get_children():
			if not pixel.hovered_on:
				pixel.modulate_sprite(Color(1.0, 1.0, 1.0))
			pixel.dark = false

func setup_grid() -> void:
	for child: Node in grid.get_children():
		child.queue_free()
	
	var pos := Vector2(0.0, 0.0)
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	for x in range(0, 53):
		for y in range(0, 25):
			var instance: Pixel = PIXEL.instantiate()
			instance.position = Vector2(x * 6, y * 7)
			grid.add_child(instance)
		
	
