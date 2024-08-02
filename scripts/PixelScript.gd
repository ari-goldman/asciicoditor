extends Area2D
class_name Pixel

const FRAME_COUNT: int = 390

signal clicked_on(pixel: Pixel)

@onready var sprite: Sprite2D = $Sprite2D
@onready var dark := false :
	set(value):
		if value:
			modulate_sprite(Global.COLORS[color_index].darkened(0.8))
		else:
			modulate_sprite(Global.COLORS[color_index])
		dark = value
		
var color_index: int
var current_index: int
var hovered_on: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_index = Global.DEFAULT_INDEX
	color_index = Global.selected_color_index
	set_frame(current_index)
	Global.selection_change.connect(_on_global_selection_change)


func set_frame(frame: int) -> void:
	sprite.frame = frame % FRAME_COUNT
	
func increase_frame() -> void:
	set_frame((sprite.frame + 1) % FRAME_COUNT)

func _on_mouse_entered() -> void:
	hovered_on = true
	if not Input.is_action_pressed("selector"):
		if Input.is_action_pressed("draw"):
			edit_pixel(Global.selected_index)
		if Input.is_action_pressed("secondary_draw"):
			edit_pixel(Global.selected_secondary_index)
				
	set_frame(Global.selected_index)
	
	if (Global.selected_index != current_index or Global.selected_color_index != color_index) and not dark:
		sprite.modulate = Global.COLORS[Global.selected_color_index].darkened(0.5)


func _on_mouse_exited() -> void:
	hovered_on = false
	set_frame(current_index)
	if not dark:
		sprite.modulate = Global.COLORS[color_index]

func _input(event: InputEvent) -> void:
	if hovered_on and not Input.is_action_pressed("selector"):
		if event.is_action_pressed("draw"):
			edit_pixel(Global.selected_index)
		if event.is_action_pressed("secondary_draw"):
			edit_pixel(Global.selected_secondary_index)

func edit_pixel(new_character_index: int) -> void:
	set_frame(new_character_index)
	color_index = Global.selected_color_index
	current_index = new_character_index % FRAME_COUNT
	if not dark:
		modulate_sprite(Global.COLORS[color_index], true)

var darken_tween: Tween
func modulate_sprite(color: Color, from_white: bool = false) -> void:
	if darken_tween:
		darken_tween.kill()
	darken_tween = get_tree().create_tween()
	darken_tween.set_parallel()
	if from_white:
		darken_tween.tween_property(sprite, "modulate", color, 0.4) \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_CUBIC) \
			.from(Color(1.0, 1.0, 1.0))
	else:
		darken_tween.tween_property(sprite, "modulate", color, 0.4) \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_CUBIC)

func _on_global_selection_change() -> void:
	if hovered_on:
		_on_mouse_entered()

func prepare_save() -> void:
	_on_mouse_exited()
	#sprite.modulate = Global.COLORS[color_index]
	if(sprite.modulate != Color(1.0, 1.0, 1.0, 1.0)):
		print(sprite.modulate)
	
