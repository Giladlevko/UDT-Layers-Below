extends MenuUI
@onready var menu_button: Button = $MarginContainer/menu_cont/menu_button


@onready var pause_menu: PauseMenu = $MarginContainer/PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.setup_UI()
	self.buttons = [menu_button]
	connect_buttons()
	SignalBus.dialog_started.connect(on_dialog_start)
	SignalBus.dialog_ended.connect(on_dialog_end)
	SignalBus.level_finished.connect(on_level_finished)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	pause_menu.toggle_visibility()
	pass # Replace with function body.


func on_dialog_start(dialog_name:String):
	menu_button.disabled = true
	tween_visibility(menu_button,false)

func on_dialog_end(dialog_name:String):
	menu_button.disabled = false
	tween_visibility(menu_button,true)


func on_level_finished():
	self.handle_scene_transition(Global.next_level_path())
