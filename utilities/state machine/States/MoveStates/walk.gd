class_name Walk extends State

@export var idle : State
@export var dash : State

func enterState() -> void:
	if parent.animation_player:
		parent.animation_player.play("walk")

func exitState() -> void:
	if parent.animation_player:
		parent.animation_player.stop()
	
func processInput(event : InputEvent) -> State:
	if !Input.get_vector("left", "right", "up", "down"):
		return idle
	if Input.is_action_just_pressed("dash"):
		return dash
	return null
	
func processPhysics(delta: float) -> State:
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction == Vector2.ZERO:
		return idle
	parent.dashDirection = direction
	parent.velocity = direction * parent.stats_component.moveSpeed
	parent.move_and_slide()
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
