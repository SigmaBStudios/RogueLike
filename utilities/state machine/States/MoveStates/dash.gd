class_name Dash extends State

@export var walk: State
@onready var dash_duration: Timer = $dashDuration
@onready var dash_cooldown: Timer = $dashCooldown

func enterState() -> void:
	if parent.hitbox_component:
		parent.hitbox_component.disabled = true
	if dash_cooldown.is_stopped():
		dash_duration.start(0.1)

func exitState() -> void:
	if parent.hitbox_component:
		parent.hitbox_component.disabled = false
	if dash_cooldown.is_stopped():
		dash_cooldown.start(1)

func processPhysics(delta: float) -> State:
	if !dash_duration.is_stopped():
		parent.velocity = parent.dashDirection * parent.stats_component.dashSpeed
		parent.move_and_slide()
		return null
	return walk
