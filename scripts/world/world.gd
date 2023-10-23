extends Node
class_name World


@export var center_node: Node3D


@onready var chunk_loader: ChunkLoader = $ChunkLoader


func _ready():
	chunk_loader.center_node = center_node


static func world_to_chunk(world_coords: Vector3) -> Vector3i:
	return (world_coords / Chunk.SIZE).floor()


static func world_to_in_chunk(world_coords: Vector3) -> Vector3:
	return world_coords - Vector3(world_to_chunk(world_coords) * Chunk.SIZE)


static func chunk_to_block(chunk_coords: Vector3i, block_in_chunk_coords: Vector3i) -> Vector3i:
	return (chunk_coords * Chunk.SIZE) + block_in_chunk_coords


static func chunk_to_world(chunk_coords: Vector3i, in_chunk_coords: Vector3) -> Vector3:
	return Vector3(chunk_coords * Chunk.SIZE) + in_chunk_coords


