extends Node2D
@onready var background = $ParallaxBackground
@onready var ringpullTimer = $"Ringpull Timer"
@onready var gearTimer = $"Gear Timer"
@onready var scoreAnimation = $ScoreAnimation
@onready var fadeAnimation = $Fade
@onready var player = $Player
@export var ringpull : PackedScene
@export var sodacan : PackedScene
@export var gear : PackedScene
var rng = RandomNumberGenerator.new()
var score : int = 0
var time_elapsed = -2
var ringpull_min_speed = 350
var ringpull_max_speed = 600
var gear_min_speed = 300
var gear_max_speed = 750
var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	timer = get_tree().create_timer(0.1)
	await timer.timeout
	fadeAnimation.play("tutorialfadein")
	timer = get_tree().create_timer(0.9)
	await timer.timeout
	fadeAnimation.play("tutorialfadeout")
	await fadeAnimation.animation_finished
	timer = get_tree().create_timer(0.2)
	await timer.timeout
	$UI/TutorialText.text = "Press (SPACE) to launch magnet"
	fadeAnimation.play("tutorialfadein")
	timer = get_tree().create_timer(0.7)
	await timer.timeout
	fadeAnimation.play("tutorialfadeout")
	await fadeAnimation.animation_finished
	timer = get_tree().create_timer(1)
	await timer.timeout
	$UI/TutorialText.text = "Avoid the falling red gears"
	fadeAnimation.play("tutorialfadein")
	timer = get_tree().create_timer(1)
	await timer.timeout
	if not player.dead:
		fadeAnimation.play("tutorialfadeout")
		await fadeAnimation.animation_finished
		$UI/TutorialText.text = "Destroy gears using your magnet"
	if not player.dead:
		fadeAnimation.play("tutorialfadein")
		timer = get_tree().create_timer(1.5)
		await timer.timeout
	if not player.dead:
		fadeAnimation.play("tutorialfadeout")
		await fadeAnimation.animation_finished


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_elapsed > 0:
		ringpull_min_speed = 200 + 100 * (log(0.1)/log(10))
		ringpull_min_speed = 500 + 100 * (log(0.1)/log(10))
		gear_min_speed = 400 + 200 * (log(0.1)/log(10))
		gear_max_speed = 700 + 200 * (log(0.1)/log(10))
		ringpullTimer.wait_time = 0.03 + 0.1 * exp(-0.005 * time_elapsed)
		gearTimer.wait_time = 0.4 + 4 * exp(-0.05 * time_elapsed)
	

func _on_ringpull_timer_timeout() -> void:
	if time_elapsed > 0:
		var instance = ringpull.instantiate()
		instance.global_position.y = -300
		instance.global_position.x = rng.randf_range(0,1920)
		add_child(instance)


func _on_gear_timer_timeout() -> void:
	if time_elapsed > 4:
		var instance = gear.instantiate()
		instance.global_position.y = -300
		instance.global_position.x = rng.randf_range(0,1920)
		add_child(instance)

func _on_soda_timer_timeout() -> void:
	if time_elapsed > 12:
		var instance = sodacan.instantiate()
		instance.global_position.y = -300
		instance.global_position.x = rng.randf_range(0,1920)
		add_child(instance)

func _on_difficulty_timer_timeout() -> void:
	time_elapsed += 1
