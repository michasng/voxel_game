extends Node
class_name World

@onready var grid_map: GridMap = $GridMap
@onready var world_generator: WorldGenerator = $WorldGenerator

@export var chunk_loader: Node3D
var chunk_loader_chunk_coords: Vector3i

var chunk_size: int:
	get:
		return grid_map.cell_octant_size

var loaded_chunks: Array[Vector3i] = []


func _process(_delta: float) -> void:
	var new_chunk_coords = world_to_chunk(chunk_loader.position)
	if new_chunk_coords != chunk_loader_chunk_coords:
		chunk_loader_chunk_coords = new_chunk_coords
		chunk_loading(chunk_loader_chunk_coords)


func chunk_loading(center_chunk_coords: Vector3i, load_distance: int = 2) -> void:
	for chunk_coords in loaded_chunks:
		var distance = (center_chunk_coords - chunk_coords).abs().length()
		if distance > load_distance:
			_unload_chunk(chunk_coords)

	for x in range(-load_distance, load_distance):
		for y in range(-load_distance, load_distance):
			for z in range(-load_distance, load_distance):
				var chunk_coords = center_chunk_coords + Vector3i(x, y, z)
				if chunk_coords not in loaded_chunks:
					_load_chunk(chunk_coords)


func _load_chunk(chunk_coords: Vector3i) -> void:
	loaded_chunks.append(chunk_coords)
	_generate_chunk(chunk_coords)


func _unload_chunk(chunk_coords: Vector3i) -> void:
	var index = loaded_chunks.find(chunk_coords)
	loaded_chunks.remove_at(index)
	_clear_chunk(chunk_coords)


func _clear_chunk(chunk_coords: Vector3i) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var in_chunk_coords = Vector3i(x, y, z)
				var world_coords = chunk_coords * chunk_size + in_chunk_coords
				grid_map.set_cell_item(world_coords, GridMap.INVALID_CELL_ITEM)


func _generate_chunk(chunk_coords: Vector3i) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var in_chunk_coords = Vector3i(x, y, z)
				var world_coords = chunk_coords * chunk_size + in_chunk_coords
				var block = world_generator.get_block(world_coords)
				if block != GridMap.INVALID_CELL_ITEM:
					grid_map.set_cell_item(world_coords, block)


func world_to_chunk(world_coords: Vector3) -> Vector3i:
	return (world_coords / chunk_size).floor()


func world_to_in_chunk(world_coords: Vector3) -> Vector3:
	return world_coords - Vector3(world_to_chunk(world_coords) * chunk_size)


func chunk_to_world(chunk_coords: Vector3i, in_chunk_coords: Vector3) -> Vector3:
	return Vector3(chunk_coords * chunk_size) + in_chunk_coords


