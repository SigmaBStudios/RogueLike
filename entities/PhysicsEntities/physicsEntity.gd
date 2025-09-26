class_name PhysicsEnity extends CharacterBody2D

signal removed(entity: PhysicsEnity)

var id: String
var knockBack: Vector2
var knockBackTimer: float

func applyKnockBack(direction: Vector2, strength: float, duration: float):
	knockBack = direction * strength
	knockBackTimer = duration

func _init(ID:String) -> void:
	id = ID

func _unhandled_input(event: InputEvent) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func _process(delta: float) -> void:
	pass
