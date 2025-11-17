extends Area2D
var rng = RandomNumberGenerator.new()
var SPEED = 500
var ROTATIONVAL = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	SPEED = rng.randf_range(350,600)
	ROTATIONVAL = rng.randf_range(-3,3)
	scale.x = rng.randf_range(0.15,0.25)
	scale.y = scale.x
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += ROTATIONVAL * delta
	position.y += SPEED * delta
