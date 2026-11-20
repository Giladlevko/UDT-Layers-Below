extends Resource
class_name InvSlotData
@export var name:String
@export_enum("Tool","Other") var slot_type = "Other"
@export var texture:AtlasTexture
@export var scene:PackedScene
@export var value:int

func clear():
	texture = null
	value = 0
