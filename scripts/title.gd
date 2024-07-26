extends CanvasLayer


func _on_start_pressed():
	$FadeToBlack/AnimationPlayer.play("fade_out")
	
func _on_fade_finished(anim_name):
	if anim_name == "fade_out":
		Main.get_node("CanvasLayer/FadeToBlack/AnimationPlayer").play("fade_in")
		# queue_free-ing immideately caused a wierd flash, this fixes it
		$QueueFreeTimer.start()

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	$Credits.visible = true

func _on_queue_free_timer_timeout():
	queue_free()
