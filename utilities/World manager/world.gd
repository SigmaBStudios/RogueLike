class_name World extends Node2D

var currentLevel

func loadLevel(levelPath: String) -> void:
	if currentLevel:
		currentLevel.queue_free()
		
	var newLevel = load(levelPath).instantiate()
	add_child(newLevel)
	currentLevel = newLevel
