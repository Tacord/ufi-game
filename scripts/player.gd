extends CharacterBody2D

@onready var sprite = $Sprite2D
const SPEED = 800.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 8
const DECELERATION = 50
const leftBound = 200
const rightBound = 1720
var target_rotation : float = 0

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
