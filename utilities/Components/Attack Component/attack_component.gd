class_name AttackComponent extends Node

@export var dmg: float
@export_enum("slash", "thrust") var dmgType: int
@export var knockbackForce: int = 60

func damage() -> float:
	return dmg
