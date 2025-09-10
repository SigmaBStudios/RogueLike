class_name Patrol extends State

@export var chase: State

var rng: RandomNumberGenerator = Global.rng

@onready var waitTimer: Timer = $Timer

@export var nav: NavigationAgent2D
@export var agroRadius: Area2D
var spawnCords: Vector2

func _ready() -> void:
	waitTimer.timeout.connect(changePoint)
	if nav:
		nav.navigation_finished.connect(_on_navigation_agent_2d_navigation_finished)
		nav.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	if agroRadius:
		agroRadius.body_entered.connect(_on_body_entered)

func getRandomPoint() -> Vector2:
	var R = 32
	var r = R * sqrt(rng.randf())
	var theta = rng.randf() * 2 * PI

	var x = spawnCords.x + r * cos(theta)
	var y = spawnCords.y + r * sin(theta)
	return Vector2(x, y)
	
func enterState() -> void:
	spawnCords = parent.global_position
	if nav:
		changePoint()
	
func exitState() -> void:
	parent.animation_player.stop()

func processPhysics(delta : float) -> State:
	if parent.target:
		return chase
	if not nav:
		return null
		
	var next_point = nav.get_next_path_position()
	var direction = global_position.direction_to(next_point)
	nav.velocity = direction * parent.stats_component.moveSpeed * 0.6
	return null
	
func processFrame(delta: float) -> State:
	if parent.velocity.x > 0:
		if parent.enemy_sprite.scale.x == 1:
			parent.enemy_sprite.scale.x = -1
	else:
		if parent.enemy_sprite.scale.x == -1:
			parent.enemy_sprite.scale.x = 1
			
	return null
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pass
		parent.target = body

func _on_navigation_agent_2d_navigation_finished() -> void:
	parent.animation_player.stop()
	waitTimer.start(randf_range(2, 3))
	
func _on_navigation_agent_2d_velocity_computed(safeVelocity) -> void:
	parent.velocity = parent.velocity.move_toward(safeVelocity, 100)
	parent.move_and_slide()

func changePoint() -> void:
	nav.target_position = getRandomPoint()
	parent.animation_player.play("walk")
