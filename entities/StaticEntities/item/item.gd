class_name Item extends Node2D

@onready var interactable: Area2D = $interactable
@export var is_interactable: bool = true
@export var interact_name: String = "item"

func interact():
	print("Picked up")
	queue_free()
