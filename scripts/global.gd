extends Node

var score = 0
var player_name = "John Doe"
var player_list = []
var instance
var BGM : PackedScene = preload("res://scenes/bgm.tscn")

# Credit: ArtinTheCoder @ Github for the amazing leaderboard system!
# https://www.youtube.com/watch?v=aF5megF14w0

func _ready() -> void:
	BGM.instantiate()
	instance = BGM.instantiate()
	add_child(instance)
	var file = FileAccess.open("res://apikey.txt", FileAccess.READ)
	var api_key = file.get_as_text().strip_edges()
	SilentWolf.configure({
		"api_key": api_key,
		"game_id": "publicufigame",
		"log_level": 1
	})
	file.close()
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/menu.tscn"
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	leaderboard()

func distort_effect():
	var node = instance.get_node("AnimationPlayer")
	node.play("distort")

func distort_effect_2():
	var node = instance.get_node("AnimationPlayer")
	node.play("distort_2")

func resume_BGM():
	instance.volume_db = -80
	instance.get_node("BGMMelody").volume_db = -6.5

func pause_BGM():
	instance.volume_db = -6.5
	instance.get_node("BGMMelody").volume_db = -80

func leaderboard():
	for score in global.score:
		global.player_list.append(global.player_name)
