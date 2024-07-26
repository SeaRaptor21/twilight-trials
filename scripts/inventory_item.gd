extends PanelContainer


var id: int = 0
var amount: int = 0
var scene = preload("res://scenes/inventory_item.tscn")

func _get_drag_data(_pos):
	var preview = scene.instantiate()
	preview.get_node("HBoxContainer/Amount").text = "%dx" % amount
	preview.get_node("HBoxContainer/Icon").texture = Game.items[id].texture
	preview.get_node("HBoxContainer/Name").text = "  "+Game.items[id].name
	modulate.a = 0.5
	set_drag_preview(preview)
	return {"id": id, "amount": amount, "ref": self}

func _can_drop_data(_pos, data):
	return data is Dictionary and data.has_all(["id","amount","ref"])

func _drop_data(_pos, _data):
	modulate.a = 1.0
	if get_parent().name == "Hotbar":
		var hb = []
		for c in get_parent().get_children():
			hb.append({"id": c.id,"amount": c.amount})
			for i in Game.inventory:
				if i.id == c.id:
					Game.inventory.erase(i)
		Game.hotbar = hb
		get_node("/root/Main").refresh_inventory()
