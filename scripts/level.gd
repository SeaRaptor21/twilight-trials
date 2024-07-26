class_name Level extends Node2D


var shadow_scene = preload("res://scenes/shadow.tscn")
var collectible_scene = preload("res://scenes/collectible.tscn")
@onready var tilemap = $TileMap
@onready var shadows_node = $Shadows
@onready var collectibles_node = $Collectibles

func ready():
	pass

func _ready():
	ready()
	Main.refresh_inventory()
	Main.refresh_recipes()
	Main.player.position = $PlayerPos.position
	for s in tilemap.get_used_cells(1):
		match tilemap.get_cell_atlas_coords(1, s):
			Vector2i(9,3):
				make_shadow(s, Game.ShadowTypes.BLOCK)
			Vector2i(3,16):
				make_shadow(s, Game.ShadowTypes.CLOAK)
		tilemap.erase_cell(1,s)
	for c in tilemap.get_used_cells(2):
		match [tilemap.get_cell_source_id(2, c), tilemap.get_cell_atlas_coords(2, c)]:
			[0, Vector2i(1,0)]:
				make_collectible(c, 0)
			[0, Vector2i(2,0)]:
				make_collectible(c, 1)
			[1, Vector2i(0,0)]:
				make_collectible(c, 2)
		tilemap.erase_cell(2,c)

func make_shadow(pos, type):
	var node = shadow_scene.instantiate()
	node.position = tilemap.to_global(tilemap.map_to_local(pos))
	node.set_type(type)
	shadows_node.add_child(node)
	return node

func make_collectible(pos, id):
	var node = collectible_scene.instantiate()
	node.position = tilemap.to_global(tilemap.map_to_local(pos))
	node.id = id
	node.amount = 1
	node.texture = Game.items[id].texture
	collectibles_node.add_child(node)
	return node
