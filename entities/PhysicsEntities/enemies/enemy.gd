class_name Enemy extends PhysicsEnity

@export var speed: float
@export var stateManager: StateManager

var target: PhysicsEnity

func _init() -> void:
	super("enemy")
	
func _ready() -> void:
	stateManager.initialize(self)

func _unhandled_input(event: InputEvent) -> void:
	stateManager.processInput(event)
	
func _physics_process(delta: float) -> void:
	stateManager.processPhysics(delta)
	
func _process(delta: float) -> void:
	stateManager.processFrame(delta)
