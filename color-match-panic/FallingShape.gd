extends Area2D

@export var color_name: String
@export var speed: float = 150.0

var active = true

signal missed(color_name: String)

func _process(delta):
	if active:
		position.y += speed * delta
		if position.y > get_viewport_rect().size.y:
			active = false
			emit_signal("missed", color_name)
			queue_free()
