extends Control
@onready var cost_label: Label = $VBoxContainer/cost_panel/costContainer/cost_label

@onready var upgrade_button: Button = $VBoxContainer/upgrade_button
@onready var buy_sfx: AudioStreamPlayer = $buy_sfx

@onready var texture_rect: TextureRect = $VBoxContainer/Panel/MarginContainer/TextureRect

const DRILL_POWER_PATH:= ("res://Assets/upgrade_icons/drill_power.png")
const DRILL_SPEED_PATH:= ("res://Assets/upgrade_icons/drill_speed.png")
const METAL_DETECTOR_RANGE_PATH:= ("res://Assets/upgrade_icons/metal_detector_range.png")
const VISON_INCREASE_PATH:= ("res://Assets/upgrade_icons/vison_increase.png")

@export_enum("drill speed", "drill power", "vision range","detactor range")
var effect:String = "drill speed"

@export var max_uses:int = 2
var current_use = 0

@export var price:int = 20:
	set(val):
		price = val
		if(is_node_ready()):
			cost_label.text = "Cost: " + str(price)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost_label.text = "Cost: " + str(price)
	pick_effect_text()
	pick_texture()
	
	pass # Replace with function body.

func pick_effect_text():
	var txt:String = ""
	match effect:
		"drill speed":
			txt = "Hammer Speed + 30%"
		"drill power":
			txt = "Drill Power + 50%"
		"vision range":
			txt = "Vison Range + 50%"
		"detactor range":
			txt = "2x Metal Detector Range"
	upgrade_button.text = txt


func pick_texture():
	var path:String = ""
	match effect:
		"drill speed":
			path = DRILL_SPEED_PATH
		"drill power":
			path = DRILL_POWER_PATH
		"vision range":
			path = VISON_INCREASE_PATH
		"detactor range":
			path = METAL_DETECTOR_RANGE_PATH
	texture_rect.texture = load(path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func handle_upgrade():
	match effect:
		"drill speed":
			Global.drill_speed *= 1.3
			pass
		"drill power":
			Global.drill_power *= 1.5
			pass
		"vision range":
			Global.vision_range *= 1.5
		"detactor range":
			Global.detactor_range *= 2


func _on_upgrade_button_pressed() -> void:
	if(Global.currency["Gems"] >= price):
		handle_upgrade()
		Global.change_currency_amount("Gems",-price)
		buy_sfx.play()
		current_use += 1
		if(current_use == max_uses):
			upgrade_button.disabled = true
			print("disabled button")
		else: price *= 2
	else:
		SignalBus.display_message.emit("Not enough Gems!")
	pass # Replace with function body.
