class_name Floor extends Node2D
var player: Player

@onready var level_manager: LevelManager = $LevelManager
@onready var entities: Node2D = $Entities

func createPlayer() -> void:
	player = load("res://entities/PhysicsEntities/player/player.tscn").instantiate()
	player.global_position = level_manager.currentRoom.spawnCordinates
	Global.player = player
	entities.add_child(player)

func _ready() -> void:
	createPlayer()
	loadGui()
	
func loadGui() -> void:
	Global.gameManager.loadGui("res://UI Elements/health bars/player_health_bar.tscn")
