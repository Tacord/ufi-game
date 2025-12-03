extends Area2D
var rng = RandomNumberGenerator.new()
var SPEED = 300
var ROTATIONVAL = 2
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += ROTATIONVAL * delta
	position.y += SPEED * delta
	
	if abs(global_position.x - magnet.global_position.x) < 300 and abs(global_position.y - magnet.global_position.y) < 400:
		var direction: Vector2 = global_position.direction_to(magnet.global_position)
		var movement_amount: Vector2 = direction * 0.5 * (600 - (abs(global_position.x - magnet.global_position.x))) * delta
		if magnet.canAttack:
			global_position += movement_amount * 0.5
		else:
			global_position += movement_amount


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		z_index = 100
		die()
		
func die():
	var timer = get_tree().create_timer(0.1, true, true, true)
	await timer.timeout
	queue_free()
