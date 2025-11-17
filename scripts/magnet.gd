extends Area2D
var canAttack : bool = true
var SPEED = 0
var lerpSpeed : float = 100
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("z") and canAttack:
		canAttack = false
		SPEED = -2700
	position.y += SPEED * delta
		
	lerpSpeed = 2000 * 1/(player.position.y - position.y)
	if position.y < 800:
		SPEED += 6000 * delta
	else:
		canAttack = true
		SPEED = 0
		position.y = 800
		
	var original_y = position.y
	position = position.lerp(player.position, lerpSpeed * delta)
	position.y = original_y
