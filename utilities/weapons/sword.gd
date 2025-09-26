class_name Sword extends Weapon

@export_enum("none", "sword", "rusty sword") var weaponType: int
	
@onready var marker = $Pivot
@onready var animation = $swordAnimation
@onready var charge_animation: AnimationPlayer = $chargeAnimation

@onready var weaponSprite: Sprite2D = $Pivot/weapon_sprite

@export var attack: AttackComponent

var chargeStartTime: int

var combo: int = 1

var weaponSprites: Dictionary = {
	1: "res://assets/weapons/swords/sword.png",
	2: "res://assets/weapons/swords/rustySword.png"
}

var attackType: Dictionary = {
	0: "slash",
	1: "thrust"
}

func _ready() -> void:
	if weaponType != 0:
		weaponSprite.texture = load(weaponSprites[weaponType])

func use(target) -> void:
	inUse = true
	# ama to target einai kati ektos vector2d tha bgalei thema
	if target.x - global_position.x < 0:
		if marker.scale.y == 1:
			marker.scale.y = -1
	else:
		if marker.scale.y == -1:
			marker.scale.y = 1

	marker.look_at(target)
	animation.speed_scale = 1 / attack.attackSpeed
	if attack.dmgType == 0:
		animation.play("attack_combo_" + attackType[attack.dmgType] + "_1")

	else:
		animation.play("attack_" + attackType[attack.dmgType])
	
func charge() -> void:
	charge_animation.speed_scale = 1 / chargeTime
	charge_animation.play("charge_" + attackType[attack.dmgType])

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		area.damage(attack)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		inUse = false
