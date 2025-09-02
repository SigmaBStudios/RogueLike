class_name HitboxComponent extends Area2D

@export var healthComponent: HealthComponent
@onready var parent := self.get_parent()
@onready var i_frames: Timer = $iFrames

var disabled: bool = false

func _ready() -> void:
	i_frames.timeout.connect(_on_timeout)

func damage(attack: AttackComponent):
	var source := attack.get_parent()
	if !disabled && healthComponent && attack.get_parent() != self.parent:
		if !(parent is Enemy and source is Enemy):
			healthComponent.updateHealth(attack.damage())
		
			
	if parent is Player && !disabled:
		Global.camera.apply_shake()
		disabled = true
		i_frames.start(0.4)
		

func _on_timeout():
	disabled = false
