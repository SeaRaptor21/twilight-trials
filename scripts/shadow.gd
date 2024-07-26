class_name Shadow extends Node2D


var type = Game.ShadowTypes.GENERIC
var overlays = {
	"block": preload("res://assets/shadows/overlays/block.png"),
	"cloak": preload("res://assets/shadows/overlays/cloak.png")
}

func _ready():
	set_type(type)
	$AnimationPlayer.seek(randf())

func set_type(new_type):
	type = new_type
	match type:
		Game.ShadowTypes.GENERIC:
			pass
		Game.ShadowTypes.BLOCK:
			var node = StaticBody2D.new()
			var collision = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(16,16)
			collision.shape = shape
			node.add_child(collision)
			add_child(node)
			$Overlay.texture = overlays.block
		Game.ShadowTypes.CLOAK:
			var node = Area2D.new()
			var collision = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(16,16)
			collision.shape = shape
			node.add_child(collision)
			add_child(node)
			$Overlay.texture = overlays.cloak
			modulate.a = 0.5
