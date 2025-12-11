extends Area2D
var rng = RandomNumberGenerator.new()
var SPEED = 300
var ROTATIONVAL = 2
@onready var player = $"../Player"
@onready var magnet = $"../Magnet"
@onready var score = $"../UI/Score"
@onready var explodetimer = $ExplodeTimer
@onready var level = $".."
@export var ringpull : PackedScene
@export var explosion : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("shake")
	rng.randomize()
	explodetimer.wait_time = rng.randf_range(4,7)
	SPEED = rng.randf_range(level.ringpull_min_speed/4,level.ringpull_max_speed/4)
	ROTATIONVAL = rng.randf_range(-1,1)
	scale.x = rng.randf_range(0.25,0.32)
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
	$CollisionShape2D.queue_free()
	level.score += 1
	level.scoreAnimation.play("addscore")
	score.text = str(level.score)
	var instance = explosion.instantiate()
	instance.global_position = global_position
	get_parent().add_child(instance)
	spawn_ringpulls(rng.randi_range(10,20))
	#$AnimationPlayer.play("collect")
	#await $AnimationPlayer.animation_finished
	queue_free()
	
func spawn_ringpulls(count : int):
	for rings in count:
		var instance = ringpull.instantiate()
		instance.global_position = global_position
		instance.target_pos = Vector2(rng.randf_range(-400,400) + global_position.x, rng.randf_range(-400,400) + global_position.y)
		get_parent().add_child(instance)
		instance.skiddadle()
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		die()


func _on_explodetimer_timeout() -> void:
	die()
