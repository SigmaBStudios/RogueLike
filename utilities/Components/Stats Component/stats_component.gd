class_name StatsComponent extends Node2D

@export var moveSpeed: float = 0.0
@export var dashSpeed: float = 0.0
@export var maxHealth: float = 0.0
@export var currentHealth: float = 0.0
@export var attackDmg: float = 0.0
@export var attackSpeed: float = 0.0
@export var defense: float = 0.0

func getMoveSpeed() -> float:
	return moveSpeed
	
func getDashSpeed() -> float:
	return dashSpeed
	
func getMaxHealth() -> float:
	return maxHealth
	
func getCurrentHealth() -> float:
	return currentHealth
	
func getAttackDmg() -> float:
	return attackDmg
	
func getAttackSpeed() -> float:
	return attackSpeed

func getDefense() -> float:
	return defense
	
func setMoveSpeed(moveSpeed: float) -> void:
	self.moveSpeed = moveSpeed
	
func setDashSpeed(dashSpeed: float) -> void:
	self.dashSpeed = dashSpeed
	
func setMaxHealth(maxHealth: float) -> void:
	self.maxHealth = maxHealth
	
func setCurrentHealth(currentHealth: float) -> void:
	self.currentHealth = currentHealth
	
func setAttackDmg(attackDmg: float) -> void:
	self.attackDmg = attackDmg
	
func setAttackSpeed(attackSpeed: float) -> void:
	self.attackSpeed = attackSpeed

func setDefense(defense: float) -> void:
	self.defense = defense
