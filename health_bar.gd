extends ProgressBar

@export var healthComponent: HealthComponent

func _ready() -> void:
	if healthComponent:
		max_value = healthComponent.maxHealth
		value = healthComponent.health

func _process(_delta: float) -> void:
	value = healthComponent.health
