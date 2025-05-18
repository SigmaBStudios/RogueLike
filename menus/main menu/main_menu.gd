extends CanvasLayer

@onready var play_button = $MainMenu/VBoxContainer/PlayButton
@onready var options_button = $MainMenu/VBoxContainer/OptionsButton
@onready var quit_button = $MainMenu/VBoxContainer/QuitButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	Global.gameManager.loadLevel("res://levels/testLevels/pathfindinglevel.tscn")

func _on_options_pressed():
	Global.gameManager.loadGui("res://menus/options/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
