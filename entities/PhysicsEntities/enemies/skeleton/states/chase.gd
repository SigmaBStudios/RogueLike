class_name Chase extends State

@export var patrol: State

@onready var timer: Timer = $Timer

@export var nav: NavigationAgent2D
@export var agroRadius: Area2D


func _ready() -> void:
	if agroRadius:
		agroRadius.body_exited.connect(_on_target_area_body_exited)
	if nav:
		nav.navigation_finished.connect(_on_navigation_agent_2d_navigation_finished)
		nav.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)

func enterState() -> void:
	if parent.target:
		nav.target_position = parent.target.global_position
	
	parent.animation_player.play("walk")
	
func exitState() -> void:
	parent.animation_player.stop()
		
	
func processPhysics(delta : float) -> State:
	if !parent.target:
		return patrol
	
	if abs(Vector2(parent.global_position - parent.target.global_position).length()) < 12:
		parent.velocity = Vector2.ZERO
		if !parent.target.hitbox_component.disabled:
			parent.weapon.marker.look_at(parent.target.global_position)
			parent.weapon.animation.play("attack_slice_2")
			parent.target.hitbox_component.damage(parent.weapon.attack)
		return null
		
	if timer.is_stopped():
		changePos()

	var next_point = nav.get_next_path_position()
	var direction = global_position.direction_to(next_point)
	if parent.knockBackTimer > 0:
		parent.velocity = parent.knockBack
		parent.knockBackTimer -= delta
		if parent.knockBackTimer <= 0:
			parent.knockBack = Vector2.ZERO
	else:
		nav.velocity = direction * parent.stats_component.moveSpeed * 0.6
	return null
	
func processFrame(delta: float) -> State:
	if parent.knockBackTimer > 0:
		return null
	if parent.velocity.x > 0:
		if parent.enemy_sprite.scale.x == 1:
			parent.enemy_sprite.scale.x = -1
	else:
		if parent.enemy_sprite.scale.x == -1:
			parent.enemy_sprite.scale.x = 1
	return null
	
func getRandomPoint() -> Vector2:
	var R = 64
	var r = R * sqrt(Global.rng.randf())
	var theta = Global.rng.randf() * 2 * PI # PI

	var x = parent.target.global_position.x + r * cos(theta)
	var y = parent.target.global_position.y + r * sin(theta)
	return Vector2(x, y)
	
func changePos() -> void:
	if parent.target:
		if abs(Vector2(parent.global_position - parent.target.global_position).length()) < 32:
			nav.target_position = parent.target.global_position
		else:
			nav.target_position = getRandomPoint()
			timer.start(0.3)
				
func _on_navigation_agent_2d_navigation_finished() -> void:
	if timer.is_stopped():
		changePos()

func _on_navigation_agent_2d_velocity_computed(safeVelocity) -> void:
	parent.velocity = parent.velocity.move_toward(safeVelocity, 100)
	parent.move_and_slide()

func _on_target_area_body_exited(body: Node2D) -> void:
	if body is Player:
		parent.target = null
