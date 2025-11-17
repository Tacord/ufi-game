extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 8
const DECELERATION = 50
const leftBound = 200
const rightBound = 1720

func _physics_process(delta: float) -> void:
	var inputDirection = Vector2.ZERO
	if Input.is_action_pressed("left") and position.x > leftBound:
		inputDirection.x -= 1
	if Input.is_action_pressed("right") and position.x < rightBound:
		inputDirection.x += 1
	
	var targetVel = inputDirection * SPEED
	
	if inputDirection.length() > 0 and position.x < rightBound and position.x > leftBound:
		inputDirection = inputDirection.normalized()
	velocity = velocity.lerp(targetVel, ACCELERATION * delta)
		

	move_and_slide()
