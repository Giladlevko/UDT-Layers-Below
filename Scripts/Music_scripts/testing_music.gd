extends Node

# This scene is for testing the music handler system

var music_handler:MusicHandler
var _mus_test_title:MUS_Base;
var _mus_test_gameplay:MUS_Base
func _ready() -> void:
	music_handler = get_node("MusicHandler");
	_mus_test_gameplay = music_handler.add_music("BGM_Gameplay");
	_mus_test_gameplay.set_volume_linear(0.2);
	_mus_test_title = music_handler.add_music("BGM_Title");
	_mus_test_title.play()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		_mus_test_title.fade_out_music(2.0, func():
			_mus_test_title.terminate_music();
		)
		_mus_test_gameplay.play()
