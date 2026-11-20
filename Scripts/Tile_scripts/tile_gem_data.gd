extends Resource
class_name TileDropData
@export_range(1,12) var max_drop:int = 1
@export_range(1,8) var min_drop:int = 1

enum types{Gem,Coal}
@export var type:types = types.Gem

func get_drop_data()->int:
	return randi_range(min_drop,max_drop)
