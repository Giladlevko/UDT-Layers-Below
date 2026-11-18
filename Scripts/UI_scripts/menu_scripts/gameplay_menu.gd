extends MenuUI

@onready var menu_button: Button = $MarginContainer/menu_cont/VBoxContainer/menu_button

@onready var pause_menu: PauseMenu = $MarginContainer/PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.setup_UI()
	self.buttons = [menu_button]
	connect_buttons()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	pause_menu.toggle_visibility()
	pass # Replace with function body.
