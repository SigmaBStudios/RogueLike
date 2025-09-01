class_name Player extends PhysicsEnity

signal flaskUpdate

@export var speed: float = 150
@export var dashSpeed: float = 800
@export var maxFlasks: int = 3
@export var flasks: int = 3

var dashDirection: Vector2 = Vector2.ZERO

@export var hitbox_component: HitboxComponent
@export var health_component: HealthComponent

@export var animation_player: AnimationPlayer
@onready var stateManager: StateManager = $StateManager
@onready var player_sprite: Sprite2D = $PlayerSprite

func _init() -> void:
	super("")

func _ready() -> void:
	stateManager.initialize(self)

func _unhandled_input(event: InputEvent) -> void:
	stateManager.processInput(event)
	
func _physics_process(delta: float) -> void:
	stateManager.processPhysics(delta)
	
func _process(delta: float) -> void:
	var mousePos := get_global_mouse_position()
	
	if self.global_position.x - mousePos.x < 0:
		if player_sprite.scale.x > 0:
			player_sprite.scale.x *= -1
	elif self.global_position.x - mousePos.x > 0:
		if player_sprite.scale.x < 0:
			player_sprite.scale.x *= -1
	stateManager.processFrame(delta)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("heal"):
		if flasks - 1 >= 0:
			flasks -= 1
			health_component.updateHealth(-20)
			flaskUpdate.emit()
