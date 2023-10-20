extends GridMap
class_name World

#var loaded_chunks: Array[Vector3] = []

var chunk_size: int:
	get:
		return cell_octant_size


func world_to_chunk(world_coords: Vector3) -> Vector3i:
	return (world_coords / chunk_size).floor()


func world_to_in_chunk(world_coords: Vector3) -> Vector3:
	return world_coords - Vector3(world_to_chunk(world_coords) * chunk_size)


func chunk_to_world(chunk_coords: Vector3i, in_chunk_coords: Vector3) -> Vector3:
	return Vector3(chunk_coords * chunk_size) + in_chunk_coords


