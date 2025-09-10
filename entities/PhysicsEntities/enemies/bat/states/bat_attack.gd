class_name BatAtack extends State

@export var notAttacking: State
@export var attack: AttackComponent
@export var attackSprite: Sprite2D
@export var marker_2d: Marker2D

@onready var attack_duration: Timer = $AttackDuration
@onready var hurt_box: Area2D = $hurtBox
@onready var collision: CollisionShape2D = $hurtBox/CollisionShape2D

func _ready() -> void:
	hurt_box.area_entered.connect(_on_area_entered)
	collision.disabled = true

func enterState() -> void:
	parent.enemy_sprite.visible = false
	attackSprite.visible = true
	collision.disabled = false
	
	parent.hitDirection = Vector2(parent.target.global_position.x - parent.global_position.x,
								parent.target.global_position.y - parent.global_position.y).normalized()
	marker_2d.look_at(parent.target.global_position)
	
	if attack_duration.is_stopped():
		attack_duration.start(0.3)
		
func exitState() -> void:
	parent.enemy_sprite.visible = true
	attackSprite.visible = false
	
	collision.disabled = true
	
func processPhysics(delta: float) -> State:
	if !attack_duration.is_stopped():
		parent.velocity = parent.hitDirection * parent.stats_component.dashSpeed
		parent.move_and_slide()
		return null
	return notAttacking
	
func _on_area_entered(area: Area2D):
	if area is HitboxComponent :
		area.damage(attack)
	
