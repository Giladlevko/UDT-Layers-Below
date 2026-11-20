extends Node


var tile_map_layer:TileMapLayer
var tile_hit_layer:TileMapLayer

var player:PLAYER



var drill_slot_data:InvSlotData = preload("res://Scripts/UI_scripts/inventory_scripts/jack_hammer_slot.tres")
var metal_detector_slot_data:InvSlotData = preload("res://Scripts/UI_scripts/inventory_scripts/metal_detector_slot.tres")

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
var vision_range:int = 4:
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

func change_currency_amount(type:String,amount:int):
	currency[type] += amount
	SignalBus.currency_changed.emit()
