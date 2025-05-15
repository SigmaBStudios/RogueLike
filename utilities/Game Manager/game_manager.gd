class_name GameManager extends Node2D

var currentScene

func _ready() -> void:
	Global.gameManager = self
	loadLevel("res://levels/testLevels/pathfindinglevel.tscn")


func loadLevel(scenePath: String) -> void:
	if currentScene:
		currentScene.queue_free()
		
	var newScene = load(scenePath).instantiate()
	add_child(newScene)
	currentScene = newScene
		
	
func loadGui(scenePath: String) -> void:
	pass
