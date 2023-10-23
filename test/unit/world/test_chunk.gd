extends GutTest

func before_all():
	Chunk.mock_size(2)

func test_for_each_block():
	var spy_called_with = []
	var spy = func(arg):
		spy_called_with.append(arg)
	
	var blocks: Array[Array] = [] # Array[Array[PackedInt32Array]]
	for x in range(Chunk.SIZE):
		blocks.append([])
		for y in range(Chunk.SIZE):
			blocks[x].append(PackedInt32Array())
			for z in range(Chunk.SIZE):
				blocks[x][y].append(1)
	
	var chunk = Chunk.new(Vector3i(0, 1, -1), blocks)
	chunk.for_each_block(spy)
	assert_eq(spy_called_with, [
		Vector3i(0, 0, 0), Vector3i(0, 0, 1),
		Vector3i(0, 1, 0), Vector3i(0, 1, 1),
		Vector3i(1, 0, 0), Vector3i(1, 0, 1),
		Vector3i(1, 1, 0), Vector3i(1, 1, 1)
	])
