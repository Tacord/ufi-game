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
@onready var ringanimation = $RingAnimation
@onready var ringbase = $RingBase
@onready var ringsizeanimation = $RingSizeUp
@onready var collect1 = $"CollectSound/1"
@onready var collect2 = $"CollectSound/2"
@onready var collect3 = $"CollectSound/3"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	ringanimation.play("ring_pulse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ringbase.rotation += 2 * delta
	currentDelta = delta
	progressbar.value = deadTimer.time_left
	if Input.is_action_just_pressed("z") and canAttack and not dead:
		ringsizeanimation.play("sizeup")
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
			var decide = rng.randi_range(1,1)
			match decide:
				1:
					collect1.pitch_scale = rng.randf_range(0.7,1.3)
					collect1.play()
				2:
					collect2.play()
					collect2.pitch_scale = rng.randf_range(0.7,1.3)
				3:
					collect3.play()
					collect3.pitch_scale = rng.randf_range(0.7,1.3)
			area.die()
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
