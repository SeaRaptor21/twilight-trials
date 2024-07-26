extends Control


@onready var container = $PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer

func _process(_delta):
	if Input.is_action_just_pressed("recipes"):
		if visible:
			_on_close_pressed()
		else:
			$"../Inventory".visible = false
			visible = true
			$PanelContainer/VBoxContainer/HBoxContainer/LineEdit.text = ""
			_on_line_edit_text_changed("")
			get_tree().paused = true

func _on_line_edit_text_changed(new_text):
	for item in container.get_children():
		if item.get_node("VBoxContainer/HBoxContainer/Name").text.to_lower().contains(new_text.to_lower()) or new_text == "":
			item.visible = true
		else:
			item.visible = false

func _on_close_pressed():
	visible = false
	get_tree().paused = false
