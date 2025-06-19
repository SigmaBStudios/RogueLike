class_name StateManager extends Node2D

var stateMachines: Array[StateMachine] = []

func initialize(parent: PhysicsEnity):
	for child in get_children():
		stateMachines.append(child)
	
	for stateMachine in stateMachines:
		stateMachine.initialize(parent)

func processInput(event):
	for stateMachine in stateMachines:
		stateMachine.processInput(event)
	
func processPhysics(delta):
	for stateMachine in stateMachines:
		stateMachine.processPhysics(delta)

func processFrame(delta):
	for stateMachine in stateMachines:
		stateMachine.processFrame(delta)
