extends GutTest


func before_all():
	Chunk.mock_size(4)


func test_world_to_chunk():
	assert_eq(World.world_to_chunk(Vector3(0, 1, 3.9)), Vector3i(0, 0, 0))
	assert_eq(World.world_to_chunk(Vector3(4, 7, 8)), Vector3i(1, 1, 2))
	assert_eq(World.world_to_chunk(Vector3(-1.5, -4, -5)), Vector3i(-1, -1, -2))


func test_world_to_in_chunk():
	assert_eq(World.world_to_in_chunk(Vector3(0, 1, 3.9)), Vector3(0, 1, 3.9))
	assert_eq(World.world_to_in_chunk(Vector3(4, 7, 8)), Vector3(0, 3, 0))
	assert_eq(World.world_to_in_chunk(Vector3(-1.5, -4, -5)), Vector3(2.5, 0, 3))


func test_chunk_to_world():
	assert_eq(World.chunk_to_world(Vector3i(0, 0, 0), Vector3(0, 1, 3.9)), Vector3(0, 1, 3.9))
	assert_eq(World.chunk_to_world(Vector3i(1, 1, 2), Vector3(0, 3, 0)), Vector3(4, 7, 8))
	assert_eq(World.chunk_to_world(Vector3i(-1, -1, -2), Vector3(2.5, 0, 3)), Vector3(-1.5, -4, -5))
