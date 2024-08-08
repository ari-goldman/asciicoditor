class_name Change

#var index: int
#var from_character: int
#var from_color: int
#var to_character: int
#var to_color: int
#
#func _init(_index: int, _from_char: int, _from_color: int, \
		#_to_char: int, _to_color: int) -> void:
	#index = _index
	#from_character = _from_char
	#from_color = _from_color
	#to_character = _to_char
	#to_color = _to_char

var index: int
var from_character: int
var from_color: int

func _init(_index: int, _from_char: int, _from_color: int) -> void:
	index = _index
	from_character = _from_char
	from_color = _from_color
