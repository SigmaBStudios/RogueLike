class_name ChargeAttack extends State

@export var attack: State
@export var weapon: Weapon
@export var chargeTimer: Timer

var charging: bool = false

func _ready() -> void:
	if chargeTimer: chargeTimer.timeout.connect(_on_timer_timeout)

func enterState() -> void:
	if chargeTimer:
		chargeTimer.start(weapon.chargeTime)
		charging = true
		weapon.attackRange.visible = true
		weapon.marker.look_at(parent.target.global_position)
		
func processFrame(delta: float) -> State:
	if charging:
		return null
	weapon.attackRange.visible = false
	return attack
	
func _on_timer_timeout():
	charging = false
