class_name Skeleton extends Enemy

@export var stateMachine: StateMachine
@export var animation_player: AnimationPlayer
@export var enemy_sprite: Sprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var weapon: Sword = $Weapon
@onready var stats_component: StatsComponent = $StatsComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $Weapon/AttackComponent

func setTarget(target: PhysicsEnity) -> void:
	self.target = target
	target.removed.connect(clearTarget)

func clearTarget() -> void:
	self.target = null

func _init() -> void:
	super("skeleton")
	
func _ready() -> void:
	
	health_component.maxHealth = stats_component.maxHealth
	health_component.health = stats_component.currentHealth
	
	attack_component.dmg = stats_component.attackDmg
	attack_component.attackSpeed = stats_component.attackSpeed
	
	stateMachine.initialize(self)

func _unhandled_input(event: InputEvent) -> void:
	stateMachine.processInput(event)
	
func _physics_process(delta: float) -> void:
	stateMachine.processPhysics(delta)
	
func _process(delta: float) -> void:
	stateMachine.processFrame(delta)
