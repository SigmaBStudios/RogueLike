class_name Room extends Node2D

signal exit

var doors = []
var map : Node2D
var width: int = 32 * 15
var height: int = 32 * 9
var spawnCordinates : Vector2
var gridIndex: Vector2

var doorBitMap: Array = [0, 0, 0, 0] # 0 up, 1 down, 2 left, 3 right

@onready var player_detector: Area2D = $playerDetector

@onready var right: TileMapLayer = preload("res://levels/tilemap layers/room_components/right_door.tscn").instantiate()
@onready var left: TileMapLayer = preload("res://levels/tilemap layers/room_components/left_door.tscn").instantiate()
@onready var up: TileMapLayer = preload("res://levels/tilemap layers/room_components/up_door.tscn").instantiate()
@onready var down: TileMapLayer = preload("res://levels/tilemap layers/room_components/down_door.tscn").instantiate()
@onready var floor: TileMapLayer = preload("res://levels/tilemap layers/room_components/floor.tscn").instantiate()
@onready var rightNoDoor: TileMapLayer = preload("res://levels/tilemap layers/room_components/right_no_door.tscn").instantiate()
@onready var leftNoDoor: TileMapLayer = preload("res://levels/tilemap layers/room_components/left_no_door.tscn").instantiate()
@onready var upNoDoor: TileMapLayer = preload("res://levels/tilemap layers/room_components/up_no_door.tscn").instantiate()
@onready var downNoDoor: TileMapLayer = preload("res://levels/tilemap layers/room_components/down_no_door.tscn").instantiate()

func setSpawn(x, y) -> void:
	spawnCordinates = Vector2(x * width + width / 2, y * height + height / 2)

func setPosition(x, y) -> void:
	global_position = Vector2(x * width, y * height)
	gridIndex = Vector2(x, y)

func _ready() -> void:
	var room = Node2D.new()
	if doorBitMap[0]:
		room.add_child(up)
	else:
		room.add_child(upNoDoor)
	if doorBitMap[1]:
		room.add_child(down)
	else:
		room.add_child(downNoDoor)
	if doorBitMap[2]:
		room.add_child(left)
	else:
		room.add_child(leftNoDoor)
	if doorBitMap[3]:
		room.add_child(right)
	else:
		room.add_child(rightNoDoor)
	room.add_child(floor)
	self.add_child(room)
	map = room
	
	player_detector.body_entered.connect(_on_room_entered)
	player_detector.body_exited.connect(_on_room_exited)

func _on_room_entered(body: Node2D):
	if body is Player:
		Events.entered_room.emit(self)

func _on_room_exited(body: Node2D):
	if body is Player:
		self.exit.emit()
