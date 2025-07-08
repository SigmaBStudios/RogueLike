class_name Idle extends State

@export var walk : State

func enterState() -> void:
	parent.velocity = Vector2.ZERO
	if parent.animation_player:
		parent.animation_player.stop()
		parent.player_sprite.frame = 0
	
func processInput(event: InputEvent) -> State:
	if Input.get_vector("left", "right", "up", "down"):
		return walk
	return null
