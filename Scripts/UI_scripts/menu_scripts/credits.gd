extends MenuUI
@onready var return_button: Button = $Panel/MarginContainer/MarginContainer/return_button
@onready var credits_song: AudioStreamPlayer = $credits_song


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.buttons = [return_button]
	connect_buttons()
	song = credits_song
	self.setup_UI()
	#Music_GLOBAL.music_gameplay.fade_out_music()
	#Music_GLOBAL.on_main_menu_on_credits_enter()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:	
	self.handle_scene_transition("res://Scenes/UI_scenes/menu_scenes/main_menue.tscn")
	Music_GLOBAL.on_main_menu_on_credits_exit()
	pass # Replace with function body.

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	base_button_pressed()
	OS.shell_open(str(meta))
