extends CharacterBody2D


const SPEED = 150.0
const FRICTION = 25.0
const JUMP_VELOCITY = -350.0

var paused := false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_jumping = false
var sounds = {
	"jump": preload("res://assets/audio/sfx/jump.ogg"),
	"hit_ground": preload("res://assets/audio/sfx/footstep_concrete_004.ogg"),
}

func _physics_process(delta):
	var jumping = false
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			jumping = true
			$AnimationPlayer.play("jump")
		elif velocity.y > 0:
			jumping = true
			$AnimationPlayer.play("fall")
	else:
		coyote_jumping = true
		$CoyoteJump.start()
	
	if paused == true:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if Input.is_action_pressed("jump") and coyote_jumping:
		velocity.y = JUMP_VELOCITY
		coyote_jumping = false
		#$SFX.stream = sounds.jump
		#$SFX.play(0.1)

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if not jumping:
			$AnimationPlayer.play("run")
		$Texture.flip_h = 0 if velocity.x > 0 else 1
	else:
		if not jumping:
			$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	move_and_slide()

func _on_hit_ground_body_entered(_body):
	$SFX.stream = sounds.hit_ground
	#$SFX.volume_db += 10
	$SFX.play()
	#$SFX.volume_db -= 10

func _on_coyote_jump_timeout():
	coyote_jumping = false

func closest(my_number:int, my_array:Array)->int:
	var closest_num: int
	var closest_delta: int = 0
	var temp_delta: int = 0
	for i in range(my_array.size()):
		if my_array[i] == my_number: return my_array[i] # exact match found!
		temp_delta = int(abs(my_array[i]-my_number))
		if closest_delta == 0 or temp_delta < closest_delta:
			closest_num = my_array[i]
		closest_delta = temp_delta
	return closest_num

func flash_bomb():
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 3*16
	area.add_child(collision)
	var sprite = Sprite2D.new()
	sprite.scale = Vector2(3,3)
	sprite.texture = load("res://assets/placeholders/explosion.png")
	area.add_child(sprite)
	area.connect("body_entered", _flash_bomb_area_entered)
	area.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(area, "scale", Vector2(1,1), 0.5)
	tween.tween_property(area, "modulate", Color(1,1,1,0), 0.1)
	tween.tween_callback(area.queue_free)
	add_child(area)
	move_child(area, 0)

func _flash_bomb_area_entered(body):
	if body.get_parent() is Shadow:
		body.get_parent().queue_free()

func shadow_block():
	var pos = Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(position))
	pos.x += -1 if $Texture.flip_h else 1
	if pos in Game.level_node.tilemap.get_used_cells(0):
		return
	for s in Game.level_node.shadows_node.get_children()+Game.level_node.collectibles_node.get_children():
		if pos == Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(s.position)):
			return
	var shadow = Game.level_node.make_shadow(pos, Game.ShadowTypes.BLOCK)
	shadow.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "scale", Vector2(1,1), 0.1)

func shadow_cloak():
	var pos = Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(position))
	pos.x += -1 if $Texture.flip_h else 1
	for s in Game.level_node.shadows_node.get_children()+Game.level_node.collectibles_node.get_children():
		if pos == Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(s.position)):
			return
	var shadow = Game.level_node.make_shadow(pos, Game.ShadowTypes.CLOAK)
	shadow.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(shadow, "scale", Vector2(1,1), 0.1)
	Game.level_node.tilemap.notify_runtime_tile_data_update(0)

func banisher():
	var pos = Vector2(Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(position)))
	for s in Game.level_node.shadows_node.get_children():
		var spos = Vector2(Game.level_node.tilemap.local_to_map(Game.level_node.tilemap.to_local(s.position)))
		if pos.distance_to(spos) <= 5:
			var a = int(rad_to_deg(pos.angle_to_point(spos)))
			var tween = get_tree().create_tween()
			match closest(wrapi(a, 0, 360), [0,90,180,360]):
				0:
					tween.tween_property(s, "position", Vector2(s.position.x+16,s.position.y), 0.1)
				90:
					tween.tween_property(s, "position", Vector2(s.position.x,s.position.y+16), 0.1)
				180:
					tween.tween_property(s, "position", Vector2(s.position.x-16,s.position.y), 0.1)
				360:
					tween.tween_property(s, "position", Vector2(s.position.x,s.position.y-16), 0.1)
			tween.tween_callback(func(): Game.level_node.tilemap.notify_runtime_tile_data_update(0))
