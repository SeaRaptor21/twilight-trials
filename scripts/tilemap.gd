extends TileMap


func _use_tile_data_runtime_update(layer, _coords):
	return layer == 0

func _tile_data_runtime_update(_layer, coords, tile_data):
	for s in $"../Shadows".get_children():
		if s.type == Game.ShadowTypes.CLOAK and local_to_map(to_local(s.position)) == coords:
			tile_data.set_collision_polygons_count(0, 0)
			return
	tile_data.set_collision_polygons_count(0, 1)
