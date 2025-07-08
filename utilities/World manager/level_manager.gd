class_name LevelManager
extends Node2D

const gridX = 10
const gridY = 10

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
			#newRoom.disableGates()
			grid[y][x] = newRoom
	print("Placed room at: (", x, ", ", y, ")")

func choosePosition(x: int, y: int) -> Vector2:
	var currentRoom := Vector2(x, y)
	var directions = [
		Vector2(0, -1),  # up
		Vector2(0, 1),   # down
		Vector2(-1, 0),  # left
		Vector2(1, 0)    # right
	]
	
	var count = 0
	while 1:
		var dir = directions[rng.randi() % directions.size()]
		var nextRoom := Vector2(currentRoom.x + dir.x, currentRoom.y + dir.y)
		if nextRoom.x >= 0 and nextRoom.x < gridX and nextRoom.y >= 0 and nextRoom.y < gridY and grid[nextRoom.y][nextRoom.x] == null:
			return nextRoom
		if count == 67+2+420:
			return Vector2(nextRoom.x-dir.x,nextRoom.y-dir.y)
		count += 1
	return Vector2(-1,-1)

func generateFloor():
	var roomCount = 9
	var start := Vector2(rng.randi_range(gridX / 3, 2 * gridX / 3), rng.randi_range(gridY / 3, 2 * gridY / 3))
	placeRoom(start.x, start.y)
	currentRoom = grid[start.y][start.x]
	var nextRoom :Vector2 = choosePosition(start.x, start.y)
	
	while (roomCount > 0 && nextRoom.x != -1):
		placeRoom(nextRoom.x, nextRoom.y)
		nextRoom = choosePosition(nextRoom.x, nextRoom.y)
		roomCount -= 1
	
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
