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
	
func processFrame(delta: float) -> State:
	var stateManager = get_parent().get_parent()
	if stateManager.stateMachines[1].currentState is Attack:
		return null
	var mousePos := get_global_mouse_position()
	
	if parent.global_position.x - mousePos.x < 0:
		if parent.player_sprite.scale.x > 0:
			parent.player_sprite.scale.x *= -1
	elif parent.global_position.x - mousePos.x > 0:
		if parent.player_sprite.scale.x < 0:
			parent.player_sprite.scale.x *= -1
	return null
