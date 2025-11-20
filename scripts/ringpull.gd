extends Area2D
var rng = RandomNumberGenerator.new()
var SPEED = 500
var ROTATIONVAL = 2
@onready var player = $"../Player"
@onready var magnet = $"../Magnet"
@onready var score = $"../UI/Score"
@onready var level = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	SPEED = rng.randf_range(level.ringpull_min_speed,level.ringpull_max_speed)
	ROTATIONVAL = rng.randf_range(-3,3)
	scale.x = rng.randf_range(0.15,0.25)
	scale.y = scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += ROTATIONVAL * delta
	position.y += SPEED * delta
	
	if not magnet.dead and abs(global_position.x - magnet.global_position.x) < 600 and abs(global_position.y - magnet.global_position.y) < 400:
		var direction: Vector2 = global_position.direction_to(magnet.global_position)
		var movement_amount: Vector2 = direction * (600 - (abs(global_position.x - magnet.global_position.x))) * delta
		if magnet.canAttack:
			global_position += movement_amount * 0.5
		else:
			global_position += movement_amount

func die():
	level.score += 1
	level.scoreAnimation.play("addscore")
	score.text = str(level.score)
	queue_free()
			

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		die()
