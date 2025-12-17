extends Node2D
@onready var background = $ParallaxBackground
var pressed = false

func _ready():
	$Transition2.play("scoretransition")

func _process(delta: float) -> void:
	background.scroll_base_offset.y += 100 * delta
	if Input.is_action_just_pressed("z") and not pressed:
		pressed = true
		global.distort_effect()
		$Transition.play("transition")
		await $Transition.animation_finished
		get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_leaderboard_timer_timeout() -> void:
	$UI/LoadingLeaderboard.text = "Unable to fetch \nleaderboard data :("
