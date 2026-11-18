extends Control
class_name CURRENCY_LABEL
@export_enum("Coal","Gems") var currency_type = "Coal"
@onready var texture_rect: TextureRect = $HBoxContainer/texPanel/TextureRect
@onready var label: Label = $HBoxContainer/labelPanel/Label
var coal_color:Color = Color(0.238, 0.238, 0.238)
var gem_color:Color = Color(0,1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.currency_changed.connect(update_label)
	update_label()
	if(currency_type == "Coal"): texture_rect.modulate = coal_color
	else: texture_rect.modulate = gem_color
	pass # Replace with function body.

func update_label():
		label.text = currency_type +": "+ str(Global.currency[currency_type])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
