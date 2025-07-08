class_name Player extends PhysicsEnity

@export var speed: float = 150
@export var dashSpeed: float = 200
var dashDirection: Vector2 = Vector2.ZERO

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
