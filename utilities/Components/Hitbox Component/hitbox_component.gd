class_name HitboxComponent extends Area2D

@export var healthComponent: HealthComponent
@onready var parent := self.get_parent()

func damage(attack: AttackComponent):
	if healthComponent && attack.get_parent().get_parent() != self.parent:
		healthComponent.updateHealth(attack.damage())
