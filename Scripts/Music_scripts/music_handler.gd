extends Node

## This is like a music player manager that handles multiple playing music instances.
class_name MusicHandler


@export var _music_dictionary:Dictionary[StringName, PackedScene]

var music_title:MUS_Title;
var music_credits:MUS_Base
var music_gameplay:MUS_Gameplay;

func _ready() -> void:
	music_title = add_music("BGM_Title");
	music_gameplay = add_music("BGM_Gameplay");

## Once the music is added it will begin playing
## The music instance will be also added to the pool of children
func add_music(music_name:StringName) -> MUS_Base:
	var packedScene:PackedScene = _music_dictionary.get(music_name);	
	if packedScene == null:
		printerr("ERROR: Could not find music name " + music_name)
		return null;
	var music_instance:MUS_Base = packedScene.instantiate();	
	add_child(music_instance)
	music_instance.process_mode = Node.PROCESS_MODE_INHERIT
	return music_instance;
	
## Stop all the music instances from playing
## If [b]kill_it[/b] is true and music instances will be removed
func stop_all_music():
	for mus:MUS_Base in get_children(false):
		mus.stop_music();
		
func pause_all_music():
	for mus:MUS_Base in get_children(false):
		if mus.is_paused():
			mus.pause_music(true);
			
func unpause_all_music():
	for mus:MUS_Base in get_children(false):
		if !mus.is_paused():
			mus.pause_music(false);

## Fade out all of the music instances from playing
## the "duration" argument will determine the fade out duration
func fadeout_all_music(duration:float = 2.0):
	for mus:MUS_Base in get_children(false):
		mus.fade_out_music(duration);


## Fade in all of the music instances from playing
## the "duration" argument will determine the fade in duration
func fadein_all_music(duration:float = 2.0):
	for mus:MUS_Base in get_children(false):
		mus.fade_in_music(duration);
