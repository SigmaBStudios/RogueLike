class_name Attack extends State

@export var notAttacking: State
@export var weapon: Weapon

func enterState() -> void:
	var pos = parent.global_position
	if weapon:
		var target
		if parent is Player:
			target = get_global_mouse_position()
		elif parent is Enemy:
			target = parent.target.global_position
		weapon.use(target)
	
func processFrame(delta: float) -> State:
	if weapon:
		if weapon.inUse:
			return null
	return notAttacking
