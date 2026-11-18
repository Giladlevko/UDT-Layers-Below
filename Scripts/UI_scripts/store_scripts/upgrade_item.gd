extends Control
@onready var cost_label: Label = $VBoxContainer/cost_panel/costContainer/cost_label

@onready var upgrade_button: Button = $VBoxContainer/upgrade_button


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
	
	pass # Replace with function body.

func pick_effect_text():
	var txt:String = ""
	match effect:
		"drill speed":
			txt = "Hammer Speed + 30%"
		"drill power":
			txt = "Drill Power + 50%"
		"vision range":
			txt = "2x Vison Range"
		"detactor range":
			txt = "2x Metal Detector Range"
	upgrade_button.text = txt

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
			Global.vision_range *= 2
		"detactor range":
			Global.detactor_range *= 2


func _on_upgrade_button_pressed() -> void:
	if(Global.currency["Gems"] >= price):
		Global.change_currency_amount("Gems",-price)
		#buy sfx here
		current_use += 1
		if(current_use == max_uses):
			upgrade_button.disabled
		else: price *= 2
	else:
		SignalBus.display_message.emit("Not enough Gems!")
	pass # Replace with function body.
