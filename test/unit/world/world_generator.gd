extends Node
class_name WorldGenerator

@export var base_terrain_height: int
@export var height_noise: FastNoiseLite
@export var height_amplitude: int


func _ready():
	height_noise.seed = randi()


func get_block(world_coords: Vector3i) -> int:
	var height = get_height(world_coords.x, world_coords.z)
	if world_coords.y < height:
		return 0
	return GridMap.INVALID_CELL_ITEM


func get_height(x: int, z: int):
	var height = base_terrain_height + int(height_noise.get_noise_2d(x, z) * height_amplitude)
	return height

