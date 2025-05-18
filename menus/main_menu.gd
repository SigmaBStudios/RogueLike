extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var music_player = $AudioStreamPlayer

# Options menu
@onready var options_popup = $OptionsPopup
@onready var volume_slider = $OptionsPopup/VBoxContainer/HBoxContainer/volume_slider
@onready var fullscreen_checkbox = $OptionsPopup/VBoxContainer/fullscreen_checkbox
@onready var back_button = $OptionsPopup/VBoxContainer/back_button

func _ready():
	# Main buttons
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Options menu
	volume_slider.value_changed.connect(_on_volume_changed)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_on_back_pressed)

	# Initial values
	volume_slider.value = db_to_linear(music_player.volume_db)
	fullscreen_checkbox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	if not music_player.playing:
		music_player.play()
	print("Main menu loaded")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/testLevels/test_level.tscn")

func _on_options_pressed():
	options_popup.popup_centered()
	get_tree().change_scene_to_file("res://menus/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	options_popup.hide()

func _on_volume_changed(value: float):
	music_player.volume_db = linear_to_db(value)

func _on_fullscreen_toggled(toggled: bool):
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
