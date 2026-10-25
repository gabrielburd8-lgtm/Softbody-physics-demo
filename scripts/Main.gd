extends Node2D

const SoftBodyBall = preload("res://scripts/SoftBodyBall.gd")

var soft_body: SoftBodyBall

func _ready() -> void:
	soft_body = SoftBodyBall.new()
	soft_body.position = Vector2(350.0, 120.0)
	soft_body.ground_y = 640.0
	soft_body.wall_left = 30.0
	soft_body.wall_right = 1250.0
	add_child(soft_body)

func _draw() -> void:
	# Floor and walls are drawn as visible boundaries for the soft body.
	draw_rect(Rect2(0, 640, 1280, 80), Color(0.35, 0.35, 0.35))
	draw_rect(Rect2(0, 0, 40, 720), Color(0.35, 0.35, 0.35))
	draw_rect(Rect2(1240, 0, 40, 720), Color(0.35, 0.35, 0.35))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if soft_body:
			soft_body.hit_at(get_global_mouse_position(), 500.0)
