extends Resource
class_name Chunk


static var SIZE: int = 8


var coords: Vector3i
var blocks: Array[Array] # Array[Array[PackedInt32Array]]]


@warning_ignore("shadowed_variable")
func _init(coords: Vector3i, blocks: Array[Array]):
	self.coords = coords
	self.blocks = blocks


func for_each_block(callable: Callable) -> void: # Callable[void, [Vector3i]]
	for x in range(SIZE):
		for y in range(SIZE):
			for z in range(SIZE):
				var in_chunk_coords = Vector3i(x, y, z)
				callable.call(in_chunk_coords)


func get_block(in_chunk_coords: Vector3i) -> int:
	return blocks[in_chunk_coords.x][in_chunk_coords.y][in_chunk_coords.z]


# setting static var from outside another class is not allowed
static func mock_size(value: int):
	SIZE = value
