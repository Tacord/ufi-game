extends Area2D
var canAttack : bool = true
var SPEED = 0
var lerpSpeed : float = 100
var currentDelta : float = 0
var dead = false

@onready var player = $"../Player"
@onready var level = $".."
@onready var score = $"../UI/Score"
@onready var collider = $CollisionShape2D
@onready var deadTimer = $"Dead Timer"
@onready var progressbar = $Progress
@onready var dieanimation = $Die

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentDelta = delta
	progressbar.value = deadTimer.time_left
	if Input.is_action_just_pressed("z") and canAttack and not dead:
		Input.start_joy_vibration(0,0,0.1,0.1)
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
	if not dead:
		if area.is_in_group("ringpull"):
			level.score += 1
			level.scoreAnimation.play("addscore")
			score.text = str(level.score)
			area.queue_free()
		if area.is_in_group("enemy"):
			Input.start_joy_vibration(0,0,0.3,0.15)
			progressbar.show()
			dieanimation.play("die")
			dead = true
			deadTimer.start()
			level.score += 3
			level.scoreAnimation.play("addscore")
			score.text = str(level.score)
			SPEED = 0
			area.queue_free()


func _on_dead_timer_timeout():
	dieanimation.play("respawn")
	progressbar.hide()
	dead = false
