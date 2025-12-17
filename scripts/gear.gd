extends Area2D
var rng = RandomNumberGenerator.new()
var SPEED = 300
var ROTATIONVAL = 2
var dead = false
@onready var player = $"../Player"
@onready var magnet = $"../Magnet"
@onready var level = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	SPEED = rng.randf_range(level.gear_min_speed,level.gear_max_speed)
	ROTATIONVAL = rng.randf_range(-2,5)
	scale.x = rng.randf_range(0.2,0.4)
	scale.y = scale.x
	$Die.scale_amount_min = scale.x * 0.35
	$Die.scale_amount_max = scale.x * 0.35

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not dead:
		$Sprite2D.rotation += ROTATIONVAL * delta
		position.y += SPEED * delta
		if position.y > 1200:
			queue_free()
		
		if abs(global_position.x - magnet.global_position.x) < 300 and abs(global_position.y - magnet.global_position.y) < 400:
			var direction: Vector2 = global_position.direction_to(magnet.global_position)
			var movement_amount: Vector2 = direction * 0.5 * (600 - (abs(global_position.x - magnet.global_position.x))) * delta
			if magnet.canAttack:
				global_position += movement_amount * 0.5
			else:
				global_position += movement_amount

func magnet_hit():
	$Die.emitting = true
	$CollisionShape2D.queue_free()
	$Sprite2D.queue_free()
	$ExplodeTimer.start()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		global.distort_effect_2()
		body.die()
		z_index = 100
		die()
		
func die():
	var timer = get_tree().create_timer(0.1, true, true, true)
	await timer.timeout
	queue_free()


func _on_explode_timer_timeout() -> void:
	queue_free()
