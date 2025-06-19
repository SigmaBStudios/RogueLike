class_name EnemyNotAttacking extends State

@export var chase: State
	
func processFrame(delta: float) -> State:
	return chase
