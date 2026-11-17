extends UI
class_name PauseMenu

@onready var resume_button: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/resume_button
@onready var inv_button: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/inv_button
@onready var back_to_main_button: Button = $VBoxContainer/Panel/MarginContainer/VBoxContainer/back_to_main_button
@onready var inventory: INVENTORY = $Inventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.buttons = [resume_button,inv_button,back_to_main_button]
	self.connect_buttons()
	self.set_button_sfx_to_global()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_visibility():
	if self.visible:
		if(inventory.visible):
			await tween_visibility(inventory,false)
		tween_visibility(self,false)
	else:
		tween_visibility(self,true)


func _on_resume_button_pressed() -> void:
	tween_visibility(self,false)
	#put unpause logic here
	pass # Replace with function body.


func _on_inv_button_pressed() -> void:
	tween_visibility(inventory,true)
	pass # Replace with function body.


func _on_back_to_main_button_pressed() -> void:
	if(owner is MenuUI):
		owner.handle_scene_transition("res://Scenes/UI_scenes/menu_scenes/main_menue.tscn")
	pass # Replace with function body.
