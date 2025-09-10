class_name BatPatrol extends State


@export var chargeAttack: State

var rng: RandomNumberGenerator = Global.rng

@onready var waitTimer: Timer = $Timer
@onready var attack_cooldown: Timer = $attackCooldown
var shouldAttack = false

@export var nav: NavigationAgent2D
@export var agroRadius: Area2D
var spawnCords: Vector2

func _ready() -> void:
	waitTimer.timeout.connect(changePoint)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	if nav:
		nav.navigation_finished.connect(_on_navigation_agent_2d_navigation_finished)
		nav.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)

func getRandomPoint() -> Vector2:
	var R = 128
	var r = R * sqrt(rng.randf())
	var theta = rng.randf() * 2 * PI

	var x = spawnCords.x + r * cos(theta)
	var y = spawnCords.y + r * sin(theta)
	return Vector2(x, y)
	
func enterState() -> void:
	parent.target = null
	parent.animation_player.play("walk")
	spawnCords = parent.global_position
	if nav:
		changePoint()
	
func exitState() -> void:
	nav.velocity = Vector2.ZERO
	parent.animation_player.stop()

func processPhysics(delta : float) -> State:
	if agroRadius.overlaps_body(Global.player):
		if attack_cooldown.is_stopped() && !shouldAttack:
			attack_cooldown.start(randf_range(2, 4))
		if shouldAttack:
			parent.target = Global.player
			shouldAttack = false
			return chargeAttack
			
	if not nav:
		return null
		
	var next_point = nav.get_next_path_position()
	var direction = global_position.direction_to(next_point)
	nav.velocity = direction * parent.stats_component.moveSpeed * 0.6
	return null

func _on_navigation_agent_2d_navigation_finished() -> void:
	changePoint()
	
func _on_navigation_agent_2d_velocity_computed(safeVelocity) -> void:
	parent.velocity = parent.velocity.move_toward(safeVelocity, 100)
	parent.move_and_slide()

func changePoint() -> void:
	nav.target_position = getRandomPoint()
	
func _on_attack_cooldown_timeout() -> void:
	shouldAttack = true
