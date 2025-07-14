extends Node2D

@onready var spawner = $ShapeSpawner
@onready var score_label = $ScoreLabel
@onready var miss_label = $MissLabel
@onready var game_over_label = $GameOverLabel

var score = 0
var misses = 0
const MAX_MISSES = 3

var colors = ["red", "blue", "green", "yellow"]
@export var shape_scene: PackedScene  # Drag in FallingShape.tscn here

func _ready():
	start_game()

func start_game():
	score = 0
	misses = 0
	game_over_label.text = ""
	spawn_loop()

func spawn_loop():
	spawn_shape()
	await get_tree().create_timer(1.2).timeout
	if misses < MAX_MISSES:
		spawn_loop()

func spawn_shape():
	var shape = shape_scene.instantiate()
	var rand_color = colors[randi() % colors.size()]
	shape.color_name = rand_color
	shape.speed = 150.0 + score * 1.5
	shape.position = Vector2(randf_range(80, 400), -50)
	shape.get_node("Sprite2D").modulate = Color(rand_color)
	shape.connect("missed", Callable(self, "on_shape_missed"))
	spawner.add_child(shape)

func on_shape_missed(color_name):
	misses += 1
	miss_label.text = "Misses: %d / %d" % [misses, MAX_MISSES]
	if misses >= MAX_MISSES:
		game_over()

func on_color_button_pressed(color_name):
	for shape in spawner.get_children():
		if shape.color_name == color_name and shape.position.y >= 300:
			shape.queue_free()
			score += 1
			score_label.text = "Score: %d" % score
			return  # Only clear one at a time

func game_over():
	game_over_label.text = "GAME OVER"


func _on_red_button_pressed() -> void:
	on_color_button_pressed("red")


func _on_blue_button_pressed() -> void:
	on_color_button_pressed("blue")


func _on_green_button_pressed() -> void:
	on_color_button_pressed("green")


func _on_yellow_button_pressed() -> void:
	on_color_button_pressed("yellow")
