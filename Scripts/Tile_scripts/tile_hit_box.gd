extends Area2D
class_name TILE_HIT_BOX

@export var block_data:BlockData

var curr_tex_coords:AtlasTexture

var max_health:int

var curr_health:int:
	set(val):
		curr_health = clamp(curr_health-val,0,max_health)
		if(curr_health < 0.66 * max_health and curr_tex_coords == block_data.default_tile):
			curr_tex_coords = block_data.cracked_tile
		elif (curr_health < 0.33 * max_health and curr_tex_coords == block_data.cracked_tile):
			curr_tex_coords = block_data.broken_tile
		elif(curr_health == 0):
			remove_tile()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = block_data.health
	curr_health = max_health
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile_pos()->Vector2:
	var local_pos:Vector2 = Global.tile_map_layer.to_local(global_position)
	var tile_pos:Vector2 = Global.tile_map_layer.local_to_map(local_pos)
	return tile_pos

func change_tile(atlas_coords:Vector2):
	var tile_pos := get_tile_pos()
	Global.tile_map_layer.set_cell(tile_pos,1,atlas_coords)

func remove_tile():
	var tile_pos := get_tile_pos()
	Global.tile_map_layer.set_cell(tile_pos,-1)
	pass

func take_damage(amount:int):
	curr_health -= amount
	
