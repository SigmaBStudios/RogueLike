extends Node2D

@export var maxHealth : float = 100
@export var health : float = maxHealth

func checkHP(dmg : float):
	if (health-dmg)<=0:
		print("dead")
	else:
		health -= dmg
