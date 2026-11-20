extends UI
class_name UpgradeStore
@onready var close_button: Button = $MarginContainer/VBoxContainer/close_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = [close_button]
	self.connect_buttons()
	set_button_sfx_to_global()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	tween_visibility(self,false)
	pass # Replace with function body.
