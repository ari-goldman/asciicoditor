extends Node

const SAVE_WINDOW = preload("res://scenes/save_window.tscn")

const DEFAULT_INDEX: int = 360
const DROPPER = preload("res://assets/dropper.png")

const COLORS := [
	Color("#ffffff"),
	Color("#999999"),
	Color("#444444"),
	Color("#ff0000"), # R
	Color("#FFA500"), # 0
	Color("#ffff00"), # Y
	Color("#00ff00"), # G
	Color("#00ffff"), # I
	Color("#0000ff"), # B
	Color("#ff00ff"), # V
]

var logic: Logic

var selected_index: int = 195
var selected_color_index: int = 0
var selected_secondary_index: int = DEFAULT_INDEX

#var changes: ChangeStack = ChangeStack.new()
var undo_redo: UndoRedo = UndoRedo.new()

signal selection_change
signal save_flash

func _ready() -> void:
	pass
	#var dropper_image: Image = DROPPER.get_image()
	#dropper_image.resize(16, 16, Image.INTERPOLATE_NEAREST)
	#DROPPER.
	#DROPPER.get_image().resize(16, 16, Image.INTERPOLATE_NEAREST)
	#print(type_string(typeof(DROPPER)))

func _input(event: InputEvent) -> void:
	if event.is_action_released("decrease_index"):
		selected_color_index = posmod(selected_color_index - 1, COLORS.size())
		selection_change.emit()
	if event.is_action_released("increase_index"):
		selected_color_index = (selected_color_index + 1) % COLORS.size()
		selection_change.emit()
	if event.is_action_pressed("save"):
		save_image()
	if event.is_action_pressed("redo"):
		undo_redo.redo()
	elif event.is_action_pressed("undo"):
		undo_redo.undo()
	if Input.is_action_pressed("dropper"):
		Input.set_default_cursor_shape(Input.CURSOR_HELP)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)


var save: FileDialog
func save_image() -> void:
	logic.prepare_save()
	await get_tree().create_timer(0.1).timeout
	var image: Image = get_viewport().get_texture().get_image()
	save_flash.emit()
	if OS.has_feature("web"):
		var buffer: PackedByteArray = image.save_png_to_buffer()
		JavaScriptBridge.download_buffer(buffer, "asciicoditor-%s.png" % Time.get_datetime_string_from_system())
	else:
		if save: 
			return
		save = SAVE_WINDOW.instantiate()
		save.current_file = ("asciicoditor-%s" % Time.get_datetime_string_from_system())
		save.current_dir = "user://"
		
		save.connect("canceled", func close() -> void:
			save.queue_free()
			save = null
		)
		
		save.connect("confirmed", func save() -> void:
			if(str(save.current_file).trim_suffix(".png").is_empty()):
				save.current_file = "asciicoditor-%s.png" % Time.get_datetime_string_from_system()
			print("cur file: " + save.current_file)
			print(save.current_path)
			image.save_png("/Users/agoldman/Desktop/asciicoditor-2024-08-01T21:20:56.png")
			save.queue_free()
			save = null
		)
		
		add_child(save)
