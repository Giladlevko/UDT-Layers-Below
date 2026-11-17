extends Node


var tile_map_layer:TileMapLayer
var tile_hit_layer:TileMapLayer

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


var currency:Dictionary[String,int] = {
	"Coal":0,
	"Gems":0
}

func change_currency_amount(type:String,amount:int):
	currency[type] += amount
	SignalBus.currency_changed.emit()
