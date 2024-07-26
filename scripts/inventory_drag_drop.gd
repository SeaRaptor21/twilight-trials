extends Control


func _can_drop_data(pos, data):
	if not data is Dictionary or not data.has_all(["id","amount","ref"]) or (name == "Hotbar" and get_child_count() >= 5 and data.ref.get_parent() != self):
		return false
	var lowest_y = 0 if get_child_count()<=0 else get_child(-1).position.y + get_child(-1).size.y
	if pos.y >= lowest_y:
		data.ref.reparent(self)
		move_child(data.ref, -1)
	else:
		var distances = []
		for c in get_children():
			distances.append(pos.distance_to(Vector2(c.position.x+c.size.x/2, c.position.y+c.size.y/2)))
		var closest_idx = distances.find(distances.min())
		data.ref.reparent(self)
		move_child(data.ref, closest_idx)
	return true

func _drop_data(_pos, data):
	data.ref.modulate.a = 1.0
	#print(name)
	var hb = []
	for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/Hotbar").get_children():
		hb.append({"id": c.id,"amount": c.amount})
	Game.hotbar = hb
	var inv = []
	for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer").get_children():
		inv.append({"id": c.id,"amount": c.amount})
	Game.inventory = inv
	Main.refresh_inventory()

#func _unhandled_input(event):
	#if event is InputEventMouseButton and not event.pressed:
		#for c in get_children():
			#c.modulate.a = 1.0
		#var hb = []
		#for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/Hotbar").get_children():
			#hb.append({"id": c.id,"amount": c.amount})
		#Game.hotbar = hb
		#var inv = []
		#for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer").get_children():
			#inv.append({"id": c.id,"amount": c.amount})
		#Game.inventory = inv
		#Main.refresh_inventory()
