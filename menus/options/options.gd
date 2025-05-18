extends CanvasLayer

@onready var volume_slider = $OptionsMenu/VBoxContainer/volume_slider
@onready var fullscreen_checkbox = $OptionsMenu/VBoxContainer/fullscreen_checkbox
@onready var back_button = $OptionsMenu/VBoxContainer/back_button

func _ready() -> void:
	volume_slider.value_changed.connect(_on_volume_changed)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_on_back_pressed)
	
	#volume_slider.value = db_to_linear(Global.gameManager.musicPLayer.volume_db)
	fullscreen_checkbox.button_pressed = Global.fullscreen

func _on_volume_changed(value: float):
	Global.gameManager.musicPlayer.volume_db = linear_to_db(value)
	
func _on_back_pressed():
	Global.gameManager.loadGui("res://menus/main menu/main_menu.tscn")
	
func _on_fullscreen_toggled(toggled: bool):
	Global.fullscreen = toggled
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
