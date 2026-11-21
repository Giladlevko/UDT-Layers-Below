extends Control
class_name CoalGoal
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar

var goal_amount = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.max_value = goal_amount
	SignalBus.coal_goal_changed.connect(set_goal)
	SignalBus.currency_changed.connect(on_currency_changed)
	pass # Replace with function body.

func set_goal(val:int):
	goal_amount = val
	progress_bar.max_value = goal_amount

func on_currency_changed():
	progress_bar.value = clamp(Global.currency["Coal"],0,progress_bar.max_value)
	if(progress_bar.value == goal_amount):
		if(!Global.quota_reached):
			Global.quota_reached = true
			SignalBus.display_message.emit("Coal Quota reached!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
