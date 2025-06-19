class_name Idle extends State

@export var walk : State

func enterState() -> void:
	parent.velocity = Vector2.ZERO
	
func processInput(event: InputEvent) -> State:
	if Input.get_vector("left", "right", "up", "down"):
		return walk
	return null
