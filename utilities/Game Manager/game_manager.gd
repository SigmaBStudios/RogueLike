class_name GameManager extends Node2D

@onready var world: World = $World
@onready var gui: GUI = $GUI
@onready var musicPlayer: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	Global.gameManager = self
	if not musicPlayer.playing && musicPlayer.stream:
		musicPlayer.play()
	loadGui("res://UI Elements/menus/main menu/main_menu.tscn")
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		gui.loadGui("res://UI Elements/menus/main menu/main_menu.tscn")

func loadLevel(scenePath: String) -> void:
	gui.unloadGui()
	world.loadLevel(scenePath)
	
func loadGui(scenePath: String) -> void:
	gui.loadGui(scenePath)
