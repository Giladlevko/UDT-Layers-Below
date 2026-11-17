extends Node2D

@onready var breakable_tile_layer: TileMapLayer = $tile_layers/TileMapLayer
@onready var hit_box_layer: TileMapLayer = $tile_layers/hit_box_layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tile_map_layer = breakable_tile_layer
	Global.tile_hit_layer = hit_box_layer
	var tiles:Array[Vector2i] = breakable_tile_layer.get_used_cells()
	for tile in tiles:
		hit_box_layer.set_cell(tile,1,Vector2i.ZERO,1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Continue Dialog"):
		SignalBus.display_message.emit("Hello! this is a test I hope this works as intended!")
	pass
