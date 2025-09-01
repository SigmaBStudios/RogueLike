extends CanvasLayer


@onready var after_hit_effect: ProgressBar = $HBoxContainer/HealthBarMargin/VBoxContainer/Control/afterHitEffect
@onready var player_health_bar: ProgressBar = $HBoxContainer/HealthBarMargin/VBoxContainer/Control/playerHealthBar
@onready var flasks: HBoxContainer = $HBoxContainer/HealthBarMargin/VBoxContainer/FlaskMargin/Flasks

var empty_flask = load("res://assets/ui sprites/flask sprites/flask_0.png")
var full_flask = load("res://assets/ui sprites/flask sprites/flask_1.png")
 
var player: Player = Global.player
var flaskCount: int = player.maxFlasks
var flaskIndex: int = flaskCount - 1

func _ready() -> void:
	player.flaskUpdate.connect(_on_flask_update)
	initHealthBar()
	initFlasks()

func initFlasks() -> void:
	for i in range(flaskCount):
		var flask = TextureRect.new()
		flask.texture = full_flask
		flasks.add_child(flask)
		
func _on_flask_update() -> void:
	var flasks = flasks.get_children()
	flasks[flaskIndex].texture = empty_flask
	flaskIndex -= 1
		
func initHealthBar() -> void:
	var healthComponent = player.health_component
	if healthComponent:
		healthComponent.damaged.connect(_on_health_update)
		player_health_bar.max_value = healthComponent.maxHealth
		player_health_bar.value = healthComponent.health
		after_hit_effect.max_value = healthComponent.maxHealth
		after_hit_effect.value = healthComponent.health

func _on_health_update(healthComponent: HealthComponent) -> void:
	if healthComponent:
		player_health_bar.value = healthComponent.health
		var tween = get_tree().create_tween()
		tween.tween_property(after_hit_effect, "value", healthComponent.health, 1).set_ease(Tween.EASE_OUT)
