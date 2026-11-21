extends Area2D
class_name TILE_HIT_BOX
@onready var sprite: Sprite2D = $Sprite2D
var tile_particle: CPUParticles2D = null
const TILE_PARTICLE = preload("res://Scenes/tile_particle.tscn")
const ORE_SCENE = preload("res://Scenes/Ore.tscn")
var curr_tex_coords:AtlasTexture


var max_health:int = 20
var tile_stage:int = 0
var freed:bool = false


var curr_health:int = 20:
	set(val):
		curr_health = clamp(val,0,max_health)
		if(curr_health < 0.66 * max_health and curr_health > 0.33 * max_health and tile_stage == 0):
			tile_stage = 1
			crack_tile()
		elif (curr_health < 0.33 * max_health and curr_health > 0 and tile_stage == 1):
			tile_stage = 2
			crack_tile()
		if(curr_health == 0 and !freed):
			tile_stage = 3
			remove_tile_and_self()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_data: = get_tile_data()
	if(tile_data): 
		var tile_name:String = tile_data.get_custom_data("TileType")
		max_health = Global.tile_health[tile_name]
		curr_health = max_health
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tile_pos()->Vector2:
	var local_pos:Vector2 = Global.tile_map_layer.to_local(global_position)
	var tile_pos:Vector2 = Global.tile_map_layer.local_to_map(local_pos)
	return tile_pos


func get_tile_data()->TileData:
	var tile_pos := get_tile_pos()
	var tile_data := Global.tile_map_layer.get_cell_tile_data(tile_pos)
	return tile_data


func crack_tile():
	handle_particle()
	Global.tile_dig_sfx.play()
	sprite.visible = true
	sprite.modulate.a = 1/5.0 * tile_stage


func remove_tile_and_self():
	crack_tile()
	freed = true
	sprite.visible = false
	var tile_pos := get_tile_pos()
	Global.tile_map_layer.set_cell.call_deferred(tile_pos,-1)
	var data := get_tile_data()
	var drop_data:TileDropData = data.get_custom_data("GemData")
	if(drop_data):
		var count = drop_data.get_drop_data()
		for i in count:
			var ore:ORE = ORE_SCENE.instantiate()
			get_tree().root.add_child(ore)
			ore.global_position = global_position
			ore.color = data.get_custom_data("ParticleColor")
			if(drop_data.type == drop_data.types.Coal):
				ore.type = ore.types.Coal
			pass

		
	await handle_particle()
	tile_particle.queue_free()
	Global.tile_hit_layer.set_cell.call_deferred(tile_pos,-1)
	
	pass

func take_damage(amount:int):
	curr_health -= amount
	

func set_particles():
	tile_particle = TILE_PARTICLE.instantiate()
	get_tree().root.add_child(tile_particle)
	tile_particle.global_position = global_position
	var data:= get_tile_data()
	tile_particle.color = data.get_custom_data("ParticleColor")

func handle_particle():
	if(!tile_particle):
		set_particles()
	if tile_particle.emitting:
		tile_particle.restart()
	
	tile_particle.emitting = true
	await tile_particle.finished
	return

	#SignalBus.emit_tile_particle.emit(16*tile_stage,color)
	#await SignalBus.particle_finished
	pass
