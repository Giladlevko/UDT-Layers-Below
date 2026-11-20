extends UI
class_name POPUPBOX
@onready var label: Label = $Panel/MarginContainer/Label
@onready var panel: Panel = $Panel

signal message_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.display_message.connect(display_message)
	message_finished.connect(display_awaiting_messages)
	setup()
	pass # Replace with function body.


func setup():
	panel.modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var message_tweening:bool
var current_message:String
var messages_to_tween:Array[String] = []
func display_message(message:String):
	if !message_tweening:
		current_message = message
		message_tweening = true
		label.text = message
		var new_panel_length = (
			(message.length()-message.count(" "))*
			label.get_theme_font_size("font_size")
			)
		panel.custom_minimum_size.x = new_panel_length
		var display_time = clampf(0.04*message.length(),1.5,6.0)
		var tween = create_tween()
		tween.tween_property(panel,"modulate",Color(1,1,1,1),0.2)
		tween.tween_interval(display_time)
		tween.tween_property(panel,"modulate",Color(1,1,1,0),0.2)
		await tween.finished
		message_tweening = false
		message_finished.emit()
	else:
		if messages_to_tween.has(message) or message == current_message:return
		messages_to_tween.append(message)

func display_awaiting_messages():
	if messages_to_tween.is_empty(): return
	var next_message = messages_to_tween.pop_front()
	display_message(next_message)
