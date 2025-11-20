extends Node2D
@onready var background = $ParallaxBackground

func _process(delta: float) -> void:
	background.scroll_base_offset.y += 100 * delta
