extends Node

## This is like a music player manager that handles multiple playing music instances.
class_name MusicHandler


@export var _music_names:Dictionary[BGM, PackedScene]

enum BGM
{
	None,
	Title,
	Gameplay
}


## Once the music is added it will begin playing
## The music instance will be also added to the pool of children
func add_music(music:BGM) -> MUS_Base:
	var packedScene:PackedScene = _music_names.get(music);
	var music_instance:MUS_Base = packedScene.instantiate();	
	add_child(music_instance)
	music_instance.process_mode = Node.PROCESS_MODE_INHERIT
	return music_instance;
	
## Stop all the music instances from playing
## If [b]kill_it[/b] is true and music instances will be removed
func stop_all_music(kill_it:bool = false):
	for mus:MUS_Base in get_children(false):
		mus.stop_music(kill_it);
		
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
## Once it fades out completely it will be removed.
func fadeout_all_music(duration:float = 2.0, kill_it:bool = false):
	for mus:MUS_Base in get_children(false):
		mus.fade_out_music(duration, kill_it);
