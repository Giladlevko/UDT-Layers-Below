extends Node2D

@onready var breakable_tile_layer: TileMapLayer = $tile_layers/TileMapLayer
@onready var hit_box_layer: TileMapLayer = $tile_layers/hit_box_layer
@onready var directional_light: DirectionalLight2D = $DirectionalLight2D

@export var level_index:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tile_map_layer = breakable_tile_layer
	Global.tile_hit_layer = hit_box_layer
	Global.current_level_index = level_index
	Global.currency["Coal"] = 0
	directional_light.visible = true
	var tiles:Array[Vector2i] = breakable_tile_layer.get_used_cells()
	for tile in tiles:
		hit_box_layer.set_cell(tile,1,Vector2i.ZERO,1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
