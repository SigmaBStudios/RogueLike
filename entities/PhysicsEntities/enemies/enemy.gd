class_name Enemy extends PhysicsEnity

var target: PhysicsEnity
var hitDirection: Vector2

func setTarget(target: PhysicsEnity) -> void:
	self.target = target
	target.removed.connect(clearTarget)

func clearTarget() -> void:
	self.target = null

func _init(id: String) -> void:
	super(id)
	
func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func _process(delta: float) -> void:
	pass
