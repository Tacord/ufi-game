extends Node2D
@onready var background = $ParallaxBackground
@onready var ringpullTimer = $"Ringpull Timer"
@onready var gearTimer = $"Gear Timer"
@onready var scoreAnimation = $ScoreAnimation
@onready var fadeAnimation = $Fade
@export var ringpull : PackedScene
@export var gear : PackedScene
var rng = RandomNumberGenerator.new()
var score : int = 0
var time_elapsed = 0
var ringpull_min_speed = 350
var ringpull_max_speed = 600
var gear_min_speed = 300
var gear_max_speed = 550

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ringpull_min_speed = 200 + 100 * (log(0.1)/log(10))
	ringpull_min_speed = 500 + 100 * (log(0.1)/log(10))
	gear_min_speed = 400 + 150 * (log(0.1)/log(10))
	gear_max_speed = 600 + 150 * (log(0.1)/log(10))
	ringpullTimer.wait_time = 0.03 + 0.1 * exp(-0.005 * time_elapsed)
	gearTimer.wait_time = 0.3 + 4 * exp(-0.05 * time_elapsed)
	

func _on_ringpull_timer_timeout() -> void:
	var instance = ringpull.instantiate()
	instance.global_position.y = -300
	instance.global_position.x = rng.randf_range(0,1920)
	add_child(instance)


func _on_gear_timer_timeout() -> void:
	if time_elapsed > 6:
		var instance = gear.instantiate()
		instance.global_position.y = -300
		instance.global_position.x = rng.randf_range(0,1920)
		add_child(instance)


func _on_difficulty_timer_timeout() -> void:
	time_elapsed += 1
