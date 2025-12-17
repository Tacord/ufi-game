extends Control

var alrpressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str(global.score)
	$FadeIn.play("fade_in")
	await $FadeIn.animation_finished
	$Fade.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter") and not alrpressed:
		$Goback.text = "Loading..."
		alrpressed = true
		if $LineEdit.text != "":
			global.player_name = $LineEdit.text
			var sw_result : Dictionary = await SilentWolf.Scores.save_score(global.player_name, global.score).sw_save_score_complete
			print("Score persisted successfully: " + str(sw_result.score_id))
			self.hide()
		$TransitionMenu.play("transition")
		await $TransitionMenu.animation_finished
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
