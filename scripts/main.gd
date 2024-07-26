extends Node2D


@onready var player = $Player

var recipe_scene = preload("res://scenes/recipe.tscn")
var inventory_item_scene = preload("res://scenes/inventory_item.tscn")
var hotbar_item_scene = preload("res://scenes/hotbar_item.tscn")

var loading_scene: Resource

func _ready():
	refresh_recipes()
	refresh_inventory()
	Game.level_node = $Level
	load_level(Game.levels[Game.level], false)

func _on_inventory_pressed():
	$CanvasLayer/Inventory.visible = true
	get_tree().paused = true

func _on_recipes_pressed():
	$CanvasLayer/Recipes.visible = true
	get_tree().paused = true

func refresh_recipes():
	for c in $CanvasLayer/Recipes/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer.get_children():
		c.queue_free()
	for r in Game.recipes:
		var node = recipe_scene.instantiate()
		node.get_node("VBoxContainer/HBoxContainer/Name").text = r.name
		node.get_node("VBoxContainer/HBoxContainer/Description").text = r.description
		for i in r.ingredients:
			var hbox = HBoxContainer.new()
			hbox.add_theme_constant_override("separation", 0)
			var amount = Label.new()
			amount.text = "%dx" % i.amount
			var icon = TextureRect.new()
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			icon.texture = Game.items[i.id].texture
			hbox.add_child(amount)
			hbox.add_child(icon)
			node.get_node("VBoxContainer/HBoxContainer2/HBoxContainer/Ingredients").add_child(hbox)
		for res in r.results:
			var hbox = HBoxContainer.new()
			hbox.add_theme_constant_override("separation", 0)
			var amount = Label.new()
			amount.text = "%dx" % res.amount
			var icon = TextureRect.new()
			icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			icon.texture = Game.items[res.id].texture
			hbox.add_child(amount)
			hbox.add_child(icon)
			node.get_node("VBoxContainer/HBoxContainer2/HBoxContainer2/Results").add_child(hbox)
		node.ingredients = r.ingredients
		node.results = r.results
		$CanvasLayer/Recipes/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer.add_child(node)

func refresh_inventory():
	for c in $CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer.get_children():
		c.queue_free()
	for i in Game.inventory:
		var node = inventory_item_scene.instantiate()
		node.get_node("HBoxContainer/Amount").text = "%dx" % i.amount
		node.get_node("HBoxContainer/Icon").texture = Game.items[i.id].texture
		node.get_node("HBoxContainer/Name").text = "  "+Game.items[i.id].name
		node.id = i.id
		node.amount = i.amount
		$CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/HFlowContainer.add_child(node)
	for c in $CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/Hotbar.get_children():
		c.queue_free()
	for i in Game.hotbar:
		var node = inventory_item_scene.instantiate()
		node.get_node("HBoxContainer/Amount").text = "%dx" % i.amount
		node.get_node("HBoxContainer/Icon").texture = Game.items[i.id].texture
		node.get_node("HBoxContainer/Name").text = "  "+Game.items[i.id].name
		node.id = i.id
		node.amount = i.amount
		$CanvasLayer/Inventory/PanelContainer/VBoxContainer/MarginContainer2/PanelContainer/MarginContainer/Hotbar.add_child(node)
	update_hotbar()
	#print("UPDATE")
	#print(Game.inventory)
	#print(Game.hotbar)

func update_hotbar():
	for c in $CanvasLayer/Control/PanelContainer2/MarginContainer/Hotbar.get_children():
		c.queue_free()
	for i in Game.hotbar:
		var node = hotbar_item_scene.instantiate()
		node.get_node("HBoxContainer/Amount").text = "%dx" % i.amount
		node.get_node("HBoxContainer/Icon").texture = Game.items[i.id].texture
		node.get_node("HBoxContainer/Name").text = "  "+Game.items[i.id].name
		node.id = i.id
		node.amount = i.amount
		$CanvasLayer/Control/PanelContainer2/MarginContainer/Hotbar.add_child(node)

func load_level(tscn_path=Game.levels[Game.level], fade=true):
	if fade:
		$CanvasLayer/FadeToBlack/AnimationPlayer.play("fade_out")
		Main.player.paused = true
	if tscn_path != "":
		loading_scene = load(tscn_path)
	if not fade:
		if Game.level_node:
			call_deferred("remove_child", Game.level_node)
		Game.level_node = loading_scene.instantiate()
		call_deferred("add_child", Game.level_node)
		call_deferred("move_child", Game.level_node, 1)
		$CanvasLayer/Control/HBoxContainer/Level.text = "Level "+str(Game.level+1)
		refresh_inventory()
		refresh_recipes()
	
func _on_fade_finished(anim_name):
	if anim_name == "fade_out":
		if Game.level >= Game.levels.size():
			get_tree().change_scene_to_file("res://scenes/end_credits.tscn")
			return
		if Game.level_node:
			call_deferred("remove_child", Game.level_node)
		Game.level_node = loading_scene.instantiate()
		call_deferred("add_child", Game.level_node)
		call_deferred("move_child", Game.level_node, 1)
		$CanvasLayer/Control/HBoxContainer/Level.text = "Level "+str(Game.level+1)
		Main.player.paused = false
		$CanvasLayer/FadeToBlack/AnimationPlayer.play("fade_in")

func _on_restart_pressed():
	load_level()
