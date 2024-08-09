extends Area2D
class_name Pixel

const FRAME_COUNT: int = 390

signal clicked_on(pixel: Pixel)

@onready var sprite: Sprite2D = $Sprite2D
		
var color_index: int
var character_index: int
var hovered_on: bool = false
var grid_index: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_color(Global.selected_color_index, true)
	_set_character(Global.DEFAULT_INDEX, true)
	Global.selection_change.connect(_color_update)


func _color_update() -> void:
	if Input.is_action_pressed("selector"):
		return
	
	if not hovered_on:
		return
	
	_set_color(Global.selected_color_index, false)


func _set_character(frame: int, permanent: bool) -> void:
	if permanent:
		character_index = frame % FRAME_COUNT
		sprite.frame = character_index
	else:
		sprite.frame = frame % FRAME_COUNT

func _set_color(_color_index: int, permanent: bool, from_white: bool = false) -> void:
	if permanent:
		color_index = _color_index % Global.COLORS.size()
	_modulate_sprite_tween(Global.COLORS[_color_index], from_white)


func _on_mouse_entered() -> void:
	hovered_on = true
	
	if Input.is_action_pressed("selector"):
		return
		
	if Input.is_action_pressed("dropper"):
		return
	
	var primary_draw: bool = Input.is_action_pressed("draw")
	var secondary_draw: bool = Input.is_action_pressed("secondary_draw")
	
	if primary_draw:
		_edit_pixel(Global.selected_index, Global.selected_color_index, true)
		return
	
	if secondary_draw:
		_edit_pixel(Global.selected_secondary_index, Global.selected_color_index, true)
		return
	
	_edit_pixel(Global.selected_index, Global.selected_color_index, false)

func _on_mouse_exited() -> void:
	hovered_on = false
	if Input.is_action_pressed("selector"):
		return
	
	refresh_pixel()

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("selector"):
		_set_character(character_index, false)
		return
	
	if not hovered_on:
		return
		
	var primary_draw: bool = Input.is_action_pressed("draw")
	var secondary_draw: bool = Input.is_action_pressed("secondary_draw")

	if not primary_draw and not secondary_draw:
		return
	
	if Input.is_action_pressed("dropper"):
		if primary_draw:
			Global.selected_index = character_index
			Global.selected_color_index = color_index
		else:
			Global.selected_secondary_index = character_index
			Global.selected_color_index = color_index
	
	if primary_draw:
		_edit_pixel(Global.selected_index, Global.selected_color_index, true)
		return
		
	if secondary_draw:
		_edit_pixel(Global.selected_secondary_index, Global.selected_color_index, true)
		return
	
	push_error("How did we get here!?")

func _edit_pixel(new_character_index: int, new_color_index: int, permanent: bool) -> void:
	if new_character_index == character_index and new_color_index == color_index:
		return
	
	if permanent:
		var ur: UndoRedo = Global.undo_redo
		ur.create_action("")
		ur.add_do_method(_set_character.bind(new_character_index, true))
		ur.add_do_method(_set_color.bind(new_color_index, true))
		ur.add_undo_method(_set_character.bind(character_index, true))
		ur.add_undo_method(_set_color.bind(color_index, true))
		ur.commit_action(false)
		
	_set_character(new_character_index, permanent)
	_set_color(new_color_index, permanent, permanent)

func refresh_pixel() -> void:
	_set_character(character_index, false)
	_set_color(color_index, false) # ensure color gets reset
	if hovered_on:
		_on_mouse_entered()

var color_tween: Tween
func _modulate_sprite_tween(color: Color, from_white: bool = false) -> void:
	if color_tween:
		color_tween.kill()
	color_tween = create_tween()
	color_tween.bind_node(self)
	
	var from_color: Color = Color(1.0, 1.0, 1.0) if from_white else sprite.modulate 
	color_tween.tween_property(sprite, "modulate", color, 0.4) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC) \
		.from(from_color)

func darken() -> void:
	_modulate_sprite_tween(Global.COLORS[color_index].darkened(0.7), false)

func lighten() -> void:
	_modulate_sprite_tween(Global.COLORS[color_index], false)	

func prepare_save() -> void:
	_set_character(character_index, false)
	_set_color(color_index, false, false)
	if(sprite.modulate != Color(1.0, 1.0, 1.0, 1.0)):
		push_error(sprite.modulate)
	
