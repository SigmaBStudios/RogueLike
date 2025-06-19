class_name StateMachine
extends Node2D

@export
var startingState : State
var currentState : State

func initialize(parent: PhysicsEnity):
	for child in get_children():
		child.parent = parent
		child.initialize()
	changeState(startingState)

func changeState(newState : State) -> void:
	if currentState:
		currentState.exitState()
	currentState = newState
	currentState.enterState()
		

func processPhysics(delta: float) -> void:
	var newState = currentState.processPhysics(delta)
	if newState:
		changeState(newState)
	
func processInput(event: InputEvent) -> void:
	var newState = currentState.processInput(event)
	if newState:
		changeState(newState)
		
func processFrame(delta: float) -> void:
	var newState = currentState.processFrame(delta)
	if newState:
		changeState(newState)
	
	
	
	
	
	
	
	
	
	
	
	
	
