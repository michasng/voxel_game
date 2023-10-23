extends GutTest

var chunk_loader: ChunkLoader

func before_all():
	chunk_loader = ChunkLoader.new()


func test_create_cube_mask():
	assert_eq(chunk_loader.create_cube_mask(1), [
		Vector3i(-1, -1, -1), Vector3i(-1, -1, 0), Vector3i(-1, -1, 1),
		Vector3i(-1, 0, -1), Vector3i(-1, 0, 0), Vector3i(-1, 0, 1),
		Vector3i(-1, 1, -1), Vector3i(-1, 1, 0), Vector3i(-1, 1, 1),
		Vector3i(0, -1, -1), Vector3i(0, -1, 0), Vector3i(0, -1, 1),
		Vector3i(0, 0, -1), Vector3i(0, 0, 0), Vector3i(0, 0, 1),
		Vector3i(0, 1, -1), Vector3i(0, 1, 0), Vector3i(0, 1, 1),
		Vector3i(1, -1, -1), Vector3i(1, -1, 0), Vector3i(1, -1, 1),
		Vector3i(1, 0, -1), Vector3i(1, 0, 0), Vector3i(1, 0, 1),
		Vector3i(1, 1, -1), Vector3i(1, 1, 0), Vector3i(1, 1, 1)
	])


func test_create_sphere_mask():
	assert_eq(chunk_loader.create_sphere_mask(1), [
		Vector3i(-1, 0, 0),
		Vector3i(0, -1, 0),
		Vector3i(0, 0, -1),
		Vector3i(0, 0, 0),
		Vector3i(0, 0, 1),
		Vector3i(0, 1, 0),
		Vector3i(1, 0, 0),
	])
