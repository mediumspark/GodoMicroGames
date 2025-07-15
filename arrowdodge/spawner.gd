extends Node2D

@export var arrow_scene: PackedScene 
@export var timer: float
@export var arrowCount : int
var arrowSpawned = false
var screen_size 

func _ready() -> void:
	screen_size = get_viewport_rect().size


func _process(delta: float) -> void:
	if timer <= 0 and not arrowSpawned:
		for n in  arrowCount:
			spawn_arrows()
		arrowSpawned = true
	else :
		timer -= delta
	

func spawn_arrows():
	var arrow = arrow_scene.instantiate()
	arrow.position = Vector2(randf_range(0, screen_size.x), 0)
	add_child(arrow)
