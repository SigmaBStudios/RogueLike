class_name LevelManager
extends Node2D

@export var gridX: int
@export var gridY: int

@onready var rng = Global.rng
var gridSize = Vector2(gridX, gridY)
var grid = []

var currentRoom: Room

# 0 up, 1 down, 2 left, 3 right
var directions = [
	Vector2(0, -1),  # up
	Vector2(0, 1),   # down
	Vector2(-1, 0),  # left
	Vector2(1, 0)    # right
]

func _ready():
	_init_grid()
	generateFloor()
	renderMap()
	var player := load("res://entities/PhysicsEntities/player/player.tscn")
	var p = player.instantiate()
	p.global_position = currentRoom.spawnCordinates
	get_parent().add_child.call_deferred(p)
	
func _on_room_change():
	print("Leaving...")

func _init_grid():
	for y in range(gridY):
		var row = []
		for x in range(gridX):
			row.append(null)
		grid.append(row)

func clearGrid():
	for y in range(gridY):
		for x in range(gridX):
			grid[y][x] = null

func placeRoom(x: int, y: int):
	if x >= 0 and x < gridX and y >= 0 and y < gridY:
		if grid[y][x] == null:
			var newRoom = load("res://utilities/World manager/room.tscn").instantiate()
			newRoom.setPosition(x, y)
			newRoom.setSpawn(x, y)
			newRoom.exit.connect(_on_room_change)
			grid[y][x] = newRoom
	print("Placed room at: (", x, ", ", y, ")")

func oppositeDoorIndex(index: int) -> int:
	match index:
		0: return 1
		1: return 0
		2: return 3
		3: return 2
	return -1
	
func generateDoors(currentRoom: Room, roomQueue: Array):
	for i in range(directions.size()):
		var r := Vector2(
			currentRoom.gridIndex.x + directions[i].x,
			currentRoom.gridIndex.y + directions[i].y
		)
		if r.x >= 0 and r.x < gridX and r.y >= 0 and r.y < gridY:
			var room = grid[r.y][r.x]
			if room:
				if room.doorBitMap[oppositeDoorIndex(i)] == 1:
					currentRoom.doorBitMap[i] = 1
	
	var doorCount
	if roomQueue.is_empty():
		doorCount = rng.randi_range(1, 4)
	else:
		doorCount = rng.randi_range(1, 3)
		
	var count = 0
	var visitedDirections = []
	while count <= doorCount:
		var dir = randi_range(0, 3)
		var nextRoom = Vector2(
			currentRoom.gridIndex.x + directions[dir].x,
			currentRoom.gridIndex.y + directions[dir].y
		)
		
		if visitedDirections.size() >= 4:
			break
		if not dir in visitedDirections:
			visitedDirections.push_back(dir)
		
		# out of bounds
		if nextRoom.x < 0 and nextRoom.x >= gridX and nextRoom.y < 0 and nextRoom.y >= gridY:
			continue
		# room already exists
		if grid[nextRoom.y][nextRoom.x] != null:
			continue
		# room in the making
		if nextRoom in roomQueue:
			continue
		# door already exists
		if currentRoom.doorBitMap[dir] == 1:
			continue
		
		currentRoom.doorBitMap[dir] = 1
		roomQueue.push_back(nextRoom)
		count += 1
		
func closeDoors() -> void:
	for i in range(gridX):
		for j in range(gridY):
			if not grid[i][j]:
				continue
			for dir in range(directions.size()):
				var r := Vector2(
					grid[i][j].gridIndex.x + directions[dir].x,
					grid[i][j].gridIndex.y + directions[dir].y
				)
				if r.x >= 0 and r.x < gridX and r.y >= 0 and r.y < gridY:
					var curRoom = grid[r.y][r.x]
					if not curRoom:
						grid[i][j].doorBitMap[dir] = 0

func generateFloor():
	var roomCount = 10
	var roomQueue := []
	var start := Vector2(rng.randi_range(gridX / 3, 2 * gridX / 3), rng.randi_range(gridY / 3, 2 * gridY / 3))
	placeRoom(start.x, start.y)
	roomCount -= 1
	currentRoom = grid[start.y][start.x]
	generateDoors(currentRoom, roomQueue)
	var nextRoom: Vector2
	while (roomCount > 0 && not roomQueue.is_empty()):
		nextRoom = roomQueue.pop_front()
		placeRoom(nextRoom.x, nextRoom.y)
		generateDoors(grid[nextRoom.y][nextRoom.x], roomQueue)
		roomCount -= 1
	
	closeDoors()
	
func renderMap():
	for child in self.get_children():
		if child is Room:
			self.remove_child(child)
	for i in range(gridY):
		for j in range(gridX):
			if grid[j][i] == null:
				continue
			self.add_child(grid[j][i])
			#var room = Sprite2D.new()
			#room.texture = load("res://icon.svg")
			#room.scale.x *= 0.5
			#room.scale.y *= 0.5
			#var width = room.texture.get_size().x * room.scale.x
			#var height = room.texture.get_size().y * room.scale.y
			#room.global_position = Vector2(i * width + width / 2,j * height + height / 2)
			#grid[j][i].add_child(room)
			
			
			var room = grid[j][i]
			var width = room.width
			var height = room.height
			room.map.global_position = Vector2(i * width,j * height)
