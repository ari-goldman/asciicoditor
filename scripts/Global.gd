extends Node

const DEFAULT_INDEX: int = 360

const COLORS := [
	Color("#ffffff"),
	Color("#999999"),
	Color("#444444"),
	Color("#ff0000"), # R
	Color("#FFA500"),
	Color("#ffff00"), # Y
	Color("#00ff00"), # G
	Color("#00ffff"), # I
	Color("#0000ff"), # B
	Color("#ff00ff"), # V
	#Color("#8ae234"),
	#Color("#fce94f"),
	#Color("#729fcf"),
	#Color("#ad7fa8"),
	#Color("#34e2e2"),
	#Color("#eeeeec"),
  #"background": "#300a24",
  #"foreground": "#eeeeec",
  #"cursorColor": "#bbbbbb",
  #"selectionBackground": "#b5d5ff"
]

var selected_index: int = 0
var selected_color_index: int = 0
var selected_secondary_index: int = DEFAULT_INDEX

signal color_change

func _input(event: InputEvent) -> void:
	if event.is_action_released("decrease_index"):
		selected_color_index = posmod(selected_color_index - 1, COLORS.size())
		color_change.emit()
	if event.is_action_released("increase_index"):
		selected_color_index = (selected_color_index + 1) % COLORS.size()
		color_change.emit()
		
func _ready() -> void:
	#DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	pass
