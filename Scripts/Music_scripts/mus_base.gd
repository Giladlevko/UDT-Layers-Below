extends Node

class_name MUS_Base

var my_stream_player:AudioStreamPlayer;
	
var my_fadeout_tween:Tween;
var is_playing:bool = false;
@export_range(0.0, 1.0, 0.001) var max_volume:float = 1.0;

## This is the volume relative to this music instance's max volume.
## e.g. if the [b]max_volume[/b] is set to [b]0.8[/b]
## and the [b]current_linear_volume[/b] is set to [b]1.0[/b]
## the volume will be set to it's [b]max_volume[/b] [b](0.8)[/b]
var current_linear_volume:float = 1.0;

@export var my_stream:AudioStream;

## Once the music is loaded into the scene, it starts playing
func _ready() -> void:
	my_stream_player = AudioStreamPlayer.new();
	add_child(my_stream_player);
	my_stream_player.bus = "music";
	my_stream_player.stream = my_stream;
	play();
	is_playing = true;
	print("Playing music : " + name)

#Play the music instance..
func play(from_position:float = 0.0) -> void:
	my_stream_player.play(from_position);
	

## This will set the volume relative to THIS music instance full volume.
## Change the music instance's max volume -> "max_volume".
func set_volume_linear(linear_vol:float) -> void:
	current_linear_volume = linear_vol;

func _process(delta: float) -> void:
	my_stream_player.volume_linear = lerp(0.0, max_volume, current_linear_volume);

## Pause the music instance.
func pause_music(is_paused:bool):
	my_stream_player.stream_paused = is_paused;
	
func is_paused() -> bool:
	return my_stream_player.stream_paused;
	
## Stop the music instance and queue it to be freed and deleted.
## If [b]kill_it[/] this will be queued up for deletion 
func stop_music(kill_it:bool = false):
	is_playing = false;
	my_stream_player.stop();
	
	if my_fadeout_tween and my_fadeout_tween.is_valid():
		my_fadeout_tween.kill();
		
	if kill_it:
		queue_free();


## Fade out the music in the duration determined by the "duration" argument.
## If [b]kill_it[/] is true and once it is fully faded out, it will be deleted
func fade_out_music(duration:float = 2.0, kill_it:bool = false):
	if my_fadeout_tween and my_fadeout_tween.is_valid():
		return;
		
	my_fadeout_tween = create_tween();
	my_fadeout_tween.tween_property(my_stream_player, "volume_linear", 0.0, duration);
	my_fadeout_tween.tween_callback(func():
		my_stream_player.stop();
		if kill_it:
			queue_free();
		is_playing = false;
	)
