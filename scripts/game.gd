extends Node


var levels := [
	"res://levels/1/level1.tscn",
	"res://levels/2/level2.tscn",
	"res://levels/3/level3.tscn",
	"res://levels/4/level4.tscn",
	"res://levels/5/level5.tscn"
]
var level_node: Node2D
var level := 0 #0

var items := [
	{"name": "Light Shard",  "texture": preload("res://assets/icons/items/0.png")},
	{"name": "Flash Bomb",   "texture": preload("res://assets/icons/items/1.png")},
	{"name": "Shadow Shard", "texture": preload("res://assets/icons/items/2.png")},
	{"name": "Shadow Block", "texture": preload("res://assets/icons/items/3.png")},
	{"name": "Shadow Cloak", "texture": preload("res://assets/icons/items/4.png")},
	{"name": "Banisher",     "texture": preload("res://assets/icons/items/5.png")},
]

var recipes := []
enum ShadowTypes {GENERIC, BLOCK, CLOAK}
var inventory := []
var hotbar := []

func get_raw_inventory():
	var res = {}
	for id in range(items.size()):
		res[id] = 0
	for i in inventory+hotbar:
		res[i.id] += i.amount
	return res

func add_to_inventory(item):
	for i in inventory+hotbar:
		if i.id == item.id:
			i.amount += item.amount
			Main.refresh_inventory()
			return
	inventory.append(item)
	Main.refresh_inventory()

func load_next_level():
	level += 1
	if level >= levels.size():
		Main.load_level("")
		return
	Main.load_level()
