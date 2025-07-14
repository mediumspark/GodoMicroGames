extends Node2D

@export var signal_time_range: Vector2 = Vector2(1.5, 3.5)
@export var swipe_window: float = 0.3
@onready var timing_indicator = $TimingIndicator
@onready var shrink_circle = $TimingIndicator/ShrinkCircle

@export var circle_end_scale: float = 1.0
@export var indicator_duration: float = 1.0  # Should match swipe_window

var signal_time = 0.0
var signaled = false
var swipe_success = false
var duel_started = false
var start_time = 0.0

@onready var signal_label = $SignalLabel
@onready var result_label = $ResultLabel

func _ready():
	start_duel()


func _process(delta):
	if duel_started and Input.is_action_just_pressed("ui_accept"):
		var now = Time.get_ticks_msec() / 1000.0
		var reaction_time = now - (start_time + signal_time)

		if signaled and abs(reaction_time) <= swipe_window:
			swipe_success = true
			result_label.text = "You Win!"
		elif not signaled:
			result_label.text = "Too Early!"
		else:
			result_label.text = "Too Slow!"

		duel_started = false
		await get_tree().create_timer(2).timeout
		start_duel()

func animate_shrink_circle():
	shrink_circle.scale = Vector2( (indicator_duration + 1) * 2.5,  (indicator_duration + 1) * 2.5)  # Start larger
	shrink_circle.position = Vector2.ZERO   # Ensure it's aligned

	var tween = create_tween()
	tween.tween_property(
		shrink_circle,
		"scale",
		Vector2(1.0, 1.0),  # Match TargetCircle
		indicator_duration
	)
	
func start_duel():
	shrink_circle.scale = Vector2( (indicator_duration + 1) * 2.5,  (indicator_duration + 1) * 2.5)  # Start larger
	shrink_circle.position = Vector2.ZERO   # Ensure it's aligned
	signal_label.text = "Ready..."
	result_label.text = ""
	signaled = false
	swipe_success = false
	duel_started = true
	shrink_circle.scale = Vector2( (indicator_duration + 1) * 2.5,  (indicator_duration + 1) * 2.5)

	signal_time = randf_range(signal_time_range.x, signal_time_range.y)
	start_time = Time.get_ticks_msec() / 1000.0

	await get_tree().create_timer(signal_time).timeout
	signal_now()


func signal_now():
	signal_label.text = ""
	signaled = true
	animate_shrink_circle()

	await get_tree().create_timer(swipe_window).timeout
	if not swipe_success:
		result_label.text = "Too Slow!"
		duel_started = false
		await get_tree().create_timer(2).timeout
		start_duel()
