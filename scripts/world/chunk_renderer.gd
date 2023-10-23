extends Node
class_name ChunkRenderer


@export var grid_map: GridMap

@export var chunk_loader: ChunkLoader


const CHUNK_RENDERING_DISTANCE = 2
@onready var chunk_rendering_mask: Array[Vector3i] = chunk_loader.create_sphere_mask(CHUNK_RENDERING_DISTANCE)


func _ready():
	chunk_loader.chunks_updated.connect(_update_render_chunks)
	chunk_loader.chunk_unloaded.connect(_clear_chunk)


func _update_render_chunks(loaded_chunks: Dictionary):
	for offset_chunk_coords in chunk_rendering_mask:
		var chunk_coords = chunk_loader.center_chunk_coords + offset_chunk_coords
		_render_chunk(loaded_chunks[chunk_coords])


func _clear_chunk(chunk: Chunk) -> void:
	var clear_block = func(block_in_chunk_coords: Vector3i):
		var block_world_coords = World.chunk_to_block(chunk.coords, block_in_chunk_coords)
		grid_map.set_cell_item(block_world_coords, GridMap.INVALID_CELL_ITEM)

	chunk.for_each_block(clear_block)


func _render_chunk(chunk: Chunk) -> void:
	var render_block = func(block_in_chunk_coords: Vector3i):
		var block = chunk.get_block(block_in_chunk_coords)
		var block_world_coords = World.chunk_to_block(chunk.coords, block_in_chunk_coords)
		if block != GridMap.INVALID_CELL_ITEM:
			grid_map.set_cell_item(block_world_coords, block) # TODO: only set items next to air or transparent blocks
	
	chunk.for_each_block(render_block)

