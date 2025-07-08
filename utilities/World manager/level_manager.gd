class_name LevelManager
extends Node2D

@export var gridX = 10
@export var gridY = 10
@export var roomCount = 10

var directions = [
		Vector2(0, -1),  # up
		Vector2(0, 1),   # down
		Vector2(-1, 0),  # left
		Vector2(1, 0)    # right
	]

@onready var rng = RandomNumberGenerator.new()
var gridSize = Vector2(gridX, gridY)
var grid = []

var currentRoom: Room

func _ready():
	_init_grid()
	generateFloor()
	renderMap()
	var player := load("res://entities/PhysicsEntities/player/player.tscn")
	var p = player.instantiate()
	p.global_position = currentRoom.spawnCordinates
	get_parent().add_child.call_deferred(p)

func _process(delta: float) -> void:
	pass

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

func generateDoors(currentRoom: Room, queue: Array):
	
	var countDoors = 0
	
	
	if queue.is_empty():
		countDoors = rng.randi_range(1,4)
	else:
		countDoors = rng.randi_range(1,3)
	
	var count = 0
	
	var visited = []
	
	while count <= countDoors:
		var i = rng.randi_range(0,3)
		var dir = directions[i]
		var newRoom = Vector2(currentRoom.gridIndex.x + dir.x,currentRoom.gridIndex.y + dir.y)
		
		if visited.size() >= 4:
			break
		if !dir in visited:
			visited.push_back(dir)
		else:
			continue
		if newRoom.x < 0 or newRoom.x >= gridX or newRoom.y < 0 or newRoom.y >= gridY:
			continue
		if grid[newRoom.y][newRoom.x] != null:
			continue
		if currentRoom.doorBitMap[i] == 1:
			continue
		if newRoom in queue:
			continue
		
		currentRoom.doorBitMap[i] = 1
		queue.push_back(newRoom)
		count += 1

func generateFloor():
	var queue = []
	var start := Vector2(rng.randi_range(gridX / 3, 2 * gridX / 3), rng.randi_range(gridY / 3, 2 * gridY / 3))
	placeRoom(start.x, start.y)
	roomCount -= 1
	currentRoom = grid[start.y][start.x]
	generateDoors(currentRoom,queue)
	var nextRoom : Vector2
	
	while (roomCount > 0 && !queue.is_empty()):
		nextRoom = queue.pop_front()
		placeRoom(nextRoom.x, nextRoom.y)
		generateDoors(grid[nextRoom.y][nextRoom.x],queue)
		roomCount -= 1
	
	connectDoors()

func connectDoors():
	for row in grid:
		for room in row:
			if !room:
				continue
			for i in range(directions.size()):
				var nextRoom = Vector2(room.gridIndex.x + directions[i].x,room.gridIndex.y + directions[i].y)
				if nextRoom.x < 0 or nextRoom.x >= gridX or nextRoom.y < 0 or nextRoom.y >= gridY:
					continue
				var neigbourRoom = grid[room.gridIndex.y + directions[i].y][room.gridIndex.x + directions[i].x]
				if neigbourRoom != null:
					room.doorBitMap[i] = 1
				else:
					room.doorBitMap[i] = 0

func renderMap():
	for child in self.get_children():
		if child is Room:
			self.remove_child(child)
	for i in range(gridY):
		for j in range(gridX):
			if grid[j][i] == null:
				continue
			self.add_child(grid[j][i])
			var room = grid[j][i]
			var width = room.width
			var height = room.height
			room.map.global_position = Vector2(i * width,j * height)
