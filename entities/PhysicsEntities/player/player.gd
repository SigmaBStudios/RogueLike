class_name Player extends PhysicsEnity

signal flaskUpdate

@export var maxFlasks: int = 3
@export var flasks: int = 3

var dashDirection: Vector2 = Vector2.ZERO

@export var hitbox_component: HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var attack_component: AttackComponent = $Weapon/AttackComponent

@export var animation_player: AnimationPlayer
@onready var stateManager: StateManager = $StateManager
@onready var player_sprite: Sprite2D = $PlayerSprite

func _init() -> void:
	super("")

func _ready() -> void:
	
	health_component.maxHealth = stats_component.maxHealth
	health_component.health = stats_component.currentHealth
	
	attack_component.dmg = stats_component.attackDmg
	attack_component.attackSpeed = stats_component.attackSpeed
	
	stateManager.initialize(self)

func _unhandled_input(event: InputEvent) -> void:
	stateManager.processInput(event)
	
func _physics_process(delta: float) -> void:
	stateManager.processPhysics(delta)
	
func _process(delta: float) -> void:
	stateManager.processFrame(delta)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("heal"):
		if flasks - 1 >= 0:
			flasks -= 1
			health_component.updateHealth(-20)
			flaskUpdate.emit()
