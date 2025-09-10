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
