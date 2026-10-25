extends Node2D

const SoftBodyBall = preload("res://scripts/SoftBodyBall.gd")

var soft_body: SoftBodyBall

func _ready() -> void:
	create_static_floor()
	create_static_wall()

	soft_body = SoftBodyBall.new()
	soft_body.position = Vector2(360.0, 180.0)
	soft_body.ground_y = 700.0
	soft_body.wall_left = 80.0
	soft_body.wall_right = 1160.0
	add_child(soft_body)

func create_static_floor() -> void:
	var floor_body = StaticBody2D.new()
	floor_body.position = Vector2(640.0, 720.0)
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(1280.0, 40.0)
	shape.shape = rect
	floor_body.add_child(shape)
	add_child(floor_body)

func create_static_wall() -> void:
	var wall_body = StaticBody2D.new()
	wall_body.position = Vector2(1120.0, 400.0)
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(40.0, 760.0)
	shape.shape = rect
	wall_body.add_child(shape)
	add_child(wall_body)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if soft_body:
			soft_body.hit_at(get_global_mouse_position(), 450.0)
