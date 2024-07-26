extends Level


func ready():
	Game.inventory = []
	Game.hotbar = []
	Game.recipes = []

func _on_goal_body_entered(body):
	if body.name == "Player":
		Game.load_next_level()
