class_name HealthComponent extends Node2D

signal damaged

@export var maxHealth : float
@export var health : float

func updateHealth(damage: float):
	if health - damage <= 0:
		get_parent().removed.emit(get_parent())
		get_parent().queue_free()
	else:
		health -= damage
	damaged.emit(self)
