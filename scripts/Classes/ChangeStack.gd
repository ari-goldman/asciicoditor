class_name ChangeStack

const MAX_SIZE: int = 10

var index: int = -1
var stack: Array[Change] = []

func add_change(change: Change) -> void:
	index += 1
	stack.resize(index + 1)
	stack[index] = change
	
	if stack.size() > MAX_SIZE:
		stack = stack.slice(1)
		index -= 1

func undo() -> Change:
	if index == 0:
		return null
	
	index -= 1
	return stack[index + 1]
	
func redo() -> Change:
	if index >= stack.size() - 1:
		return null
	
	index += 1
	return stack[index - 1]
