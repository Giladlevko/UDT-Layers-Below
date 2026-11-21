extends Node


var tile_map_layer:TileMapLayer
var tile_hit_layer:TileMapLayer

var player:PLAYER

var exit_door_position:Vector2
var exit_door:ExitDoor

var drill_slot_data:InvSlotData = preload("res://Scripts/UI_scripts/inventory_scripts/jack_hammer_slot.tres")
var metal_detector_slot_data:InvSlotData = preload("res://Scripts/UI_scripts/inventory_scripts/metal_detector_slot.tres")

var npc_dialog_data:DialogData = preload("res://Scripts/UI_scripts/text_box/dialogs/general_npc_dialogs.tres")

var puzzle_sfx_stream: = preload("res://Assets/sfx_assets/SFX_PuzzleComplete.ogg")
@onready var puzzle_complete_sfx:AudioStreamPlayer = AudioStreamPlayer.new()


var tile_health:Dictionary[String,int] = {
	"DarkStone": 100,
	"LightStone":70,
	"LightDirt":20,
	"Wood":40,
	"DarkDirt":30,
	"DarkSandyDirt":40,
	"LightSandyDirt":30,
	"Pumpkin":5,
	"Slime":10,
	"DarkGreenGem":130,
	"DarkBlackGem":150,
	"DarkBlueGem":170,
	"DarkPinkGem":190,
	"LightGreenGem":130,
	"LightBlackGem":150,
	"LightBlueGem":170,
	"LightPinkGem":190,
	
}

var drill_speed:float = 1
var drill_power:float = 10
var vision_range:int = 5:
	set(val):
		vision_range = val
		SignalBus.vision_range_changed.emit()
var detactor_range:int = 100:
	set(val):
		detactor_range = val
		SignalBus.detector_range_changed.emit()

var currency:Dictionary[String,int] = {
	"Coal":0,
	"Gems":0
}


var quota_reached:bool = false


func _ready() -> void:
	puzzle_sfx_setup()
	SignalBus.puzzle_solved.connect(on_puzzle_complete)

func change_currency_amount(type:String,amount:int):
	currency[type] += amount
	SignalBus.currency_changed.emit()


func puzzle_sfx_setup():
	puzzle_complete_sfx.stream = puzzle_sfx_stream
	puzzle_complete_sfx.volume_db = -20
	puzzle_complete_sfx.bus = "sfx"
	get_tree().root.add_child.call_deferred(puzzle_complete_sfx)

func on_puzzle_complete():
	print("playing")
	puzzle_complete_sfx.play()
