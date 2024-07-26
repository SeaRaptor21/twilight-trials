extends CanvasLayer


const SPEED = 150.0
var scrolling = false

func _ready():
	# For some reason setting visible to false doesn't work but this does
	$Control/RichTextLabel.get_child(0, true).rotation_degrees = -90

func _process(delta):
	if scrolling:
		$Control/RichTextLabel.get_child(0, true).value += delta*SPEED

func _on_fade_finished(anim_name):
	if anim_name == "fade_in":
		scrolling = true
