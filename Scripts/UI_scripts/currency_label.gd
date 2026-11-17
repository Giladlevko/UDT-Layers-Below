extends Control
@export var tex_color:Color
@export_enum("Coal","Gems") var currency_type = "Coal"
@onready var texture_rect: TextureRect = $HBoxContainer/texPanel/TextureRect
@onready var label: Label = $HBoxContainer/labelPanel/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.currency_changed.connect(update_label)
	update_label()
	texture_rect.modulate = tex_color
	pass # Replace with function body.

func update_label():
		label.text = currency_type +": "+ str(Global.currency[currency_type])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
