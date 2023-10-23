extends Node
class_name ChunkLoader

@export var world_generator: WorldGenerator


signal chunks_updated(loaded_chunks: Dictionary)

signal chunk_loaded(chunk: Chunk)

signal chunk_unloaded(chunk: Chunk)


var center_node: Node3D
var center_chunk_coords: Vector3i

const CHUNK_LOADING_DISTANCE = 3
@onready var chunk_loading_mask: Array[Vector3i] = create_sphere_mask(CHUNK_LOADING_DISTANCE)

var loaded_chunks: Dictionary = {} # Dictionary[Vector3i, Chunk]


func create_cube_mask(radius: int) -> Array[Vector3i]:
	var mask: Array[Vector3i] = []
	var chunk_range = range(-radius, radius + 1)
	for x in chunk_range:
		for y in chunk_range:
			for z in chunk_range:
				var chunk_coords = Vector3i(x, y, z)
				mask.append(chunk_coords)
	return mask


func create_sphere_mask(radius: int) -> Array[Vector3i]:
	var within_radius = func(chunk_coords: Vector3i) -> bool:
		return chunk_coords.length() <= radius # length() result is absolute
	return create_cube_mask(radius).filter(within_radius)


func _process(_delta: float) -> void:
	var new_center_chunk_coords = World.world_to_chunk(center_node.position)
	if new_center_chunk_coords != center_chunk_coords:
		center_chunk_coords = new_center_chunk_coords
		_update_chunks()


func _update_chunks() -> void:
	for chunk_coords in loaded_chunks.keys():
		var distance = (center_chunk_coords - chunk_coords).length()
		if distance > CHUNK_LOADING_DISTANCE:
			_unload_chunk(chunk_coords)

	for offset_chunk_coords in chunk_loading_mask:
		var chunk_coords = center_chunk_coords + offset_chunk_coords
		if chunk_coords not in loaded_chunks:
			_load_chunk(chunk_coords)

	chunks_updated.emit(loaded_chunks)


func _load_chunk(chunk_coords: Vector3i) -> void:
	var chunk = world_generator.generate_chunk(chunk_coords)
	loaded_chunks[chunk_coords] = chunk

	chunk_loaded.emit(chunk)


func _unload_chunk(chunk_coords: Vector3i) -> void:
	var chunk = loaded_chunks[chunk_coords]
	loaded_chunks.erase(chunk_coords)

	chunk_unloaded.emit(chunk)
