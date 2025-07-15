extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var playernum = 0
var screen_size # Size of the game window.

signal hit

func _ready():
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	print("Hit!!")
	$CollisionShape2D.set_deferred("disabled", true)


func _on_area_entered(area: Area2D) -> void:
	hit.emit()
	print("Hit!!")
	$CollisionShape2D.set_deferred("disabled", true) # Replace with function body.
