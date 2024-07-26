extends Level


func ready():
	Game.inventory = []
	Game.hotbar = []
	Game.recipes = [
		{
			"name": "Flash Bomb",
			"description": "An item that causes an intense flash of light within a small radius, banishing Shadows",
			"ingredients": [
				{"id": 0, "amount": 3}
			],
			"results": [
				{"id": 1, "amount": 1}
			]
		},
		{
			"name": "Shadow Block",
			"description": "Use to spwan a shadow block directly in front of you",
			"ingredients": [
				{"id": 0, "amount": 1},
				{"id": 2, "amount": 3}
			],
			"results": [
				{"id": 3, "amount": 1}
			]
		}
	]

func _on_goal_body_entered(body):
	if body.name == "Player":
		Game.load_next_level()
