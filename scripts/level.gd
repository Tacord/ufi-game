extends Node2D
@onready var background = $ParallaxBackground
@onready var ringpullTimer = $"Ringpull Timer"
@onready var gearTimer = $"Gear Timer"
@onready var scoreAnimation = $ScoreAnimation
@export var ringpull : PackedScene
@export var gear : PackedScene
var rng = RandomNumberGenerator.new()
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background.scroll_base_offset.y += 200 * delta
	

func _on_ringpull_timer_timeout() -> void:
	var instance = ringpull.instantiate()
	instance.global_position.y = -300
	instance.global_position.x = rng.randf_range(0,1920)
	add_child(instance)


func _on_gear_timer_timeout() -> void:
	var instance = gear.instantiate()
	instance.global_position.y = -300
	instance.global_position.x = rng.randf_range(0,1920)
	add_child(instance)
