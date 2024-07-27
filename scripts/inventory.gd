extends Control


@onready var container = $PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		if visible:
			_on_close_pressed()
		else:
			$"../Recipes".visible = false
			visible = true
			$PanelContainer/VBoxContainer/HBoxContainer/LineEdit.text = ""
			_on_line_edit_text_changed("")
			get_tree().paused = true

func _on_line_edit_text_changed(new_text):
	for item in container.get_children():
		if item.get_node("HBoxContainer/Name").text.to_lower().contains(new_text.to_lower()) or new_text == "":
			item.visible = true
		else:
			item.visible = false

func _on_close_pressed():
	visible = false
	get_tree().paused = false

#func _can_drop_data(_pos, data):
	#return data is Dictionary and data.has_all(["id","amount","ref"])

#func _drop_data(_pos, data):
	#data.ref.modulate.a = 1.0
	#var hb = []
	#for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/Hotbar").get_children():
		#hb.append({"id": c.id,"amount": c.amount})
	#Game.hotbar = hb
	#var inv = []
	#for c in get_node("/root/Main/CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer").get_children():
		#inv.append({"id": c.id,"amount": c.amount})
	#Game.inventory = inv
	#Main.refresh_inventory()
