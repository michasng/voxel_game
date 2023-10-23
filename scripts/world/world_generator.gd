extends Node
class_name WorldGenerator

@export var base_terrain_height: int
@export var height_noise: FastNoiseLite
@export var height_amplitude: int


func _ready():
	height_noise.seed = randi()


func generate_chunk(chunk_coords: Vector3i) -> Chunk:
	var blocks: Array[Array] = []
	for x in range(Chunk.SIZE):
		blocks.append([])
		for y in range(Chunk.SIZE):
			blocks[x].append(PackedInt32Array())
			for z in range(Chunk.SIZE):
				var in_chunk_coords = Vector3i(x, y, z)
				var world_coords = chunk_coords * Chunk.SIZE + in_chunk_coords
				var block = get_block(world_coords)
				blocks[x][y].append(block)
	return Chunk.new(chunk_coords, blocks)


func get_block(world_coords: Vector3i) -> int:
	var height = get_height(world_coords.x, world_coords.z)
	if world_coords.y < height:
		return 0
	return GridMap.INVALID_CELL_ITEM


func get_height(x: int, z: int):
	var height = base_terrain_height + int(height_noise.get_noise_2d(x, z) * height_amplitude)
	return height

