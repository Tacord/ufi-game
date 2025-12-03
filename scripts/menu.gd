extends Node2D
@onready var background = $ParallaxBackground

func _process(delta: float) -> void:
	background.scroll_base_offset.y += 100 * delta
	if Input.is_action_just_pressed("z"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_leaderboard_timer_timeout() -> void:
	$UI/LoadingLeaderboard.text = "Unable to fetch \nleaderboard data :("
