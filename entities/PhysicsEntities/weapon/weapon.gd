class_name Weapon extends Node2D

@export_enum("none", "sword", "rusty sword") var weaponType: int
	
@onready var marker = $Pivot
@onready var animation = $swordAnimation
@onready var charge_animation: AnimationPlayer = $chargeAnimation

@onready var weaponSprite: Sprite2D = $Pivot/Marker2D/weapon_sprite
@export var attack: AttackComponent
@onready var progress_bar: ProgressBar = $Pivot/hitbox/ProgressBar


@export var chargeTime: float = 0.0
var chargeStartTime: int
var inUse: bool = false

var weaponSprites: Dictionary = {
	1: "res://assets/weapons/swords/sword.png",
	2: "res://assets/weapons/swords/rustySword.png"
}

var attackType: Dictionary = {
	0: "slash",
	1: "thrust"
}

var attackNumber: int = 1

func _ready() -> void:
	if weaponType != 0:
		weaponSprite.texture = load(weaponSprites[weaponType])

func use(target) -> void:
	inUse = true
	charge_animation.play("set_" + attackType[attack.dmgType])
	if attack.dmgType == 0:
		if attackNumber == 1:
			animation.play("attack_" + attackType[attack.dmgType] + "_" + str(attackNumber))
			attackNumber += 1
		elif attackNumber == 2:
			animation.play("attack_" + attackType[attack.dmgType] + "_" + str(attackNumber))
			attackNumber -= 1
	else:
		animation.play("attack_" + attackType[attack.dmgType] + "_" + str(attackNumber))
	
	marker.look_at(target)
	
	if get_global_mouse_position().x - target.x < 0:
		if marker.scale.y == 1:
			marker.scale.y = -1
	else:
		if marker.scale.y == -1:
			marker.scale.y = 1
			
func charge() -> void:
	charge_animation.speed_scale = 1 / chargeTime
	charge_animation.play("charge_" + attackType[attack.dmgType])

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		area.damage(attack)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		inUse = false
