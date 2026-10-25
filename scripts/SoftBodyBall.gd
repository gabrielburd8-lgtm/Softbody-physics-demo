extends Node2D

@export var point_count: int = 16
@export var radius: float = 110.0
@export var gravity: float = 850.0
@export var ground_y: float = 640.0
@export var wall_left: float = 30.0
@export var wall_right: float = 1250.0

var points: Array = []
var springs: Array = []

func _ready() -> void:
	generate_shape()
	queue_redraw()

func generate_shape() -> void:
	points.clear()
	springs.clear()

	for i in range(point_count):
		var angle = TAU * i / float(point_count)
		var offset = Vector2(cos(angle), sin(angle)) * radius
		points.append({
			"pos": Vector2.ZERO + offset,
			"vel": Vector2.ZERO,
		})

	for i in range(point_count):
		add_spring(i, (i + 1) % point_count)
		add_spring(i, (i + 2) % point_count)
		add_spring(i, (i + point_count / 2) % point_count)

func add_spring(a_index: int, b_index: int) -> void:
	var rest_length = (points[a_index]["pos"] - points[b_index]["pos"]).length()
	springs.append({
		"a": a_index,
		"b": b_index,
		"rest_length": rest_length,
	})

func _physics_process(delta: float) -> void:
	for _iteration in range(5):
		solve_springs()

	for item in points:
		var p = item
		p["vel"] += Vector2(0.0, gravity) * delta
		p["vel"] *= 0.992
		p["pos"] += p["vel"] * delta

		if p["pos"].x < wall_left:
			p["pos"].x = wall_left
			p["vel"].x = abs(p["vel"].x) * 0.35
		elif p["pos"].x > wall_right:
			p["pos"].x = wall_right
			p["vel"].x = -abs(p["vel"].x) * 0.35

		if p["pos"].y > ground_y:
			p["pos"].y = ground_y
			p["vel"].y = -abs(p["vel"].y) * 0.45

		if p["pos"].y < 30.0:
			p["pos"].y = 30.0
			p["vel"].y = abs(p["vel"].y) * 0.2

	var center = Vector2.ZERO
	for item in points:
		center += item["pos"]
	center /= points.size()

	for item in points:
		var offset = item["pos"] - center
		if offset.length() > radius * 1.5:
			item["pos"] = center + offset.normalized() * radius * 1.5

	queue_redraw()

func solve_springs() -> void:
	for spring in springs:
		var a = points[spring["a"]]
		var b = points[spring["b"]]
		var delta = b["pos"] - a["pos"]
		var distance = max(0.001, delta.length())
		var difference = (distance - spring["rest_length"]) / distance
		var correction = delta * 0.5 * difference

		a["pos"] += correction
		b["pos"] -= correction

func hit_at(position: Vector2, strength: float = 400.0) -> void:
	for item in points:
		var offset = item["pos"] - position
		var distance = offset.length()
		if distance < 180.0:
			var push = 1.0 - (distance / 180.0)
			item["vel"] += offset.normalized() * push * strength * 0.35

func _draw() -> void:
	if points.size() < 3:
		return

	var polygon: PackedVector2Array = []
	for item in points:
		polygon.append(item["pos"])

	draw_colored_polygon(polygon, Color(0.18, 0.75, 1.0, 0.8))
	for i in range(points.size()):
		var current = points[i]["pos"]
		var next = points[(i + 1) % points.size()]["pos"]
		draw_line(current, next, Color(1.0, 1.0, 1.0, 0.8), 2.0)

	for item in points:
		draw_circle(item["pos"], 4.0, Color(1.0, 1.0, 1.0, 0.9))
