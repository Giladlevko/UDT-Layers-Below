extends Node

# This scene is for testing the music handler system

var music_handler:MusicHandler
var _mus_test:MUS_Title;
func _ready() -> void:
	music_handler = get_node("MusicHandler");
	_mus_test = music_handler.add_music(MusicHandler.BGM.Title);
	_mus_test.switch_to_settings();
	_mus_test.set_volume_linear(1.0)
	
