extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var cam = $Camera2D
@onready var level = $".."
@onready var magnet = $"../Magnet"
@onready var screenshake = $ScreenShake
const SPEED = 800.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 8
const DECELERATION = 50
const leftBound = 100
const rightBound = 1820
var target_rotation : float = 0
var current_time_scale = 1
var dead = false

func _physics_process(delta: float) -> void:
	var inputDirection = Vector2.ZERO
	target_rotation = 0
	if Input.is_action_pressed("left") and position.x > leftBound:
		target_rotation = deg_to_rad(-10)
		inputDirection.x -= 1
	if Input.is_action_pressed("right") and position.x < rightBound:
		inputDirection.x += 1
		target_rotation = deg_to_rad(10)

	sprite.rotation = lerp(sprite.rotation, target_rotation, 10 * delta)

	var targetVel = inputDirection * SPEED
	
	if inputDirection.length() > 0 and position.x < rightBound and position.x > leftBound:
		inputDirection = inputDirection.normalized()
	velocity = velocity.lerp(targetVel, ACCELERATION * delta)
		

	move_and_slide()

func freeze(duration: float, time_scale : float = 0):
	sprite.modulate = Color(10000,10000,10000) 
	current_time_scale = Engine.time_scale
	Engine.time_scale = time_scale
	var timer = get_tree().create_timer(duration, true, true, true)
	await timer.timeout
	Engine.time_scale = current_time_scale
	sprite.modulate = Color(1,1,1) 

func die():
	dead = true
	$DieSound.play()
	velocity = Vector2(0,0)
	Input.start_joy_vibration(0,0,0.6,0.15)
	global.score = level.score
	$CollisionShape2D.queue_free()
	magnet.collider.queue_free()
	$"../Death".show()
	z_index = 100
	freeze(0.1,0)
	$Die.play("die")
	level.fadeAnimation.play("fade")
	await level.fadeAnimation.animation_finished
	get_tree().change_scene_to_file("res://scenes/score_screen.tscn")
