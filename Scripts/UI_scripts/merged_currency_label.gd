extends Control

@onready var coal_label: Label = $Panel/MarginContainer/coalContainer/coal_label
@onready var gem_label: Label = $Panel/MarginContainer/GemContainer/gem_label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.currency_changed.connect(on_currency_changed)
	gem_label.text = str(Global.currency["Gems"])
	coal_label.text = str(Global.currency["Coal"])
	pass # Replace with function body.

var in_tween:bool = false
var dur:int = 3
func on_currency_changed():
	gem_label.text = str(Global.currency["Gems"])
	coal_label.text = str(Global.currency["Coal"])
	return
	in_tween = true
	var tween:=create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,1),0.3)
	tween.tween_interval(dur)
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.3)
	await tween.finished
	in_tween = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
