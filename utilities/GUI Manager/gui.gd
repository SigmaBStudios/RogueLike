class_name GUI extends Node2D

var currentGui: CanvasLayer

func loadGui(guiPath: String) -> void:
	if currentGui:
		currentGui.queue_free()
		
	var newGui = load(guiPath).instantiate()
	add_child(newGui)
	currentGui = newGui

func unloadGui() -> void:
	if currentGui:
		currentGui.queue_free()
		currentGui = null
