extends Area2D
var canAttack : bool = true
var SPEED = 0
var lerpSpeed : float = 100
var currentDelta : float = 0

@onready var player = $"../Player"
@onready var level = $".."
@onready var score = $"../UI/Score"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentDelta = delta
	if Input.is_action_just_pressed("z") and canAttack:
		canAttack = false
		SPEED = -2000
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

func _on_area_entered(area):
	if area.is_in_group("ringpull"):
		level.score += 1
		level.scoreAnimation.play("addscore")
		score.text = str(level.score)
		area.queue_free()
	if area.is_in_group("enemy"):
		level.score += 3
		level.scoreAnimation.play("addscore")
		score.text = str(level.score)
		SPEED = 0
		area.queue_free()
