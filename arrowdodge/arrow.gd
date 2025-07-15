extends Area2D

@export var speed: float = 250.0

var active = true


func _process(delta: float) -> void:
	if active : 
		position.y += speed * delta
		if position.y > get_viewport_rect().size.y:
			active = false
			queue_free()


func _on_area_entered(area: Area2D) -> void:
	if(area.name.contains("Player")):
		speed = 0
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Ground"):
		speed = 0
