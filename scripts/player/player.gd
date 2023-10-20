extends CharacterBody3D
class_name Player


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const MOUSE_SENSITIVITY = 0.003

@export var world: World
var chunk_coords: Vector3i

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready
var camera: Camera3D = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	chunk_coords = world.world_to_chunk(position)


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = get_flat_move_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	var new_chunk_coords = world.world_to_chunk(position)
	if new_chunk_coords != chunk_coords:
		chunk_coords = new_chunk_coords
		world.chunk_loading(chunk_coords)


func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		camera.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)


func get_view_direction() -> Transform3D:
	return camera.global_transform

func get_input_direction() -> Vector3:
	var input_dir_2d = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	return Vector3(input_dir_2d.x, 0, input_dir_2d.y)

func get_spatial_move_direction() -> Vector3:
	return (get_view_direction().basis * get_input_direction()).normalized()

func get_flat_move_direction() -> Vector3:
	var spatial_move_dir = get_spatial_move_direction()
	return Vector3(spatial_move_dir.x, 0, spatial_move_dir.z).normalized()

