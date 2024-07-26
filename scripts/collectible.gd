extends Node2D


var id: int
var amount: int
var texture: Resource

func _ready():
	$Area/Texture.texture = texture

func _on_body_entered(body):
	if body.name == "Player":
		Game.add_to_inventory({"id": id, "amount": amount})
		$Area.disconnect("body_entered", _on_body_entered)
		$AnimationPlayer.play("collect")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
