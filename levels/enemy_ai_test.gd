extends Node2D

var rng = RandomNumberGenerator.new()
var create: bool = false
func _ready() -> void:
	create = true
	
func _process(delta: float) -> void:
	if create:
		createTarget()
		create = false
		
func createTarget():
	var target = load("res://entities/PhysicsEntities/npcs/target.tscn")
	var t = target.instantiate()
	t.removed.connect(died)
	t.global_position = Vector2(rng.randf_range(100, 900), rng.randf_range(100, 500))
	t.scale.x = 3
	t.scale.y = 3
	self.add_child(t)

func died():
	create = true
