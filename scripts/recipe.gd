extends PanelContainer


var ingredients := []
var results := []

func craft():
	# Assumes all items of one id are all in the same inventory item.
	var old_inv = Game.inventory
	var old_hb = Game.hotbar
	for i in ingredients:
		if Game.get_raw_inventory()[i.id] >= i.amount:
			for item in Game.inventory+Game.hotbar:
				if item.id == i.id:
					item.amount -= i.amount
					if item.amount <= 0:
						if Game.inventory.has(item):
							Game.inventory.erase(item)
						else:
							Game.hotbar.erase(item)
					break
		else:
			Game.inventory = old_inv
			Game.hotbar = old_hb
			set_text_for_duration("Not enough resources", 1.0)
			return
	for r in results:
		Game.add_to_inventory(r)
	get_node("/root/Main").refresh_inventory()
	set_text_for_duration("Done", 1.0)

func _on_craft_pressed():
	craft()

func set_text_for_duration(text, duration):
	$VBoxContainer/HBoxContainer2/Craft.text = text
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	$VBoxContainer/HBoxContainer2/Craft.text = "Craft"
