extends MenuUI
@onready var return_button: Button = $Panel/MarginContainer/MarginContainer/return_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.buttons = [return_button]
	connect_buttons()
	self.setup_UI()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	Music_GLOBAL.music_title.fade_in_music(2.0);
	var old_credits_music:MUS_Base = Music_GLOBAL.music_credits;
	Music_GLOBAL.music_credits = null;
	old_credits_music.fade_out_music(2.0, func():
		old_credits_music.terminate_music();
	)
	
	self.handle_scene_transition("res://Scenes/UI_scenes/menu_scenes/main_menue.tscn")
	pass # Replace with function body.
