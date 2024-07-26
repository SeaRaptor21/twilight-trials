extends StaticBody2D


var speed = 50.0
var paused = false

@onready var moving_to = $End

func _ready():
	position = $Start.position

func _physics_process(delta):
	if paused:
		return
	position = position.move_toward(moving_to.position, delta*speed)
	if position == moving_to.position:
		moving_to = $Start if moving_to==$End else $End
		paused = true
		$Timer.start()

func _on_timer_timeout():
	paused = false
