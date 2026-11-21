extends Node

class_name MUS_Base

var my_stream_player:AudioStreamPlayer;
	
var my_fadeout_tween:Tween;
var is_playing:bool = false;
var play_from_position:float = 0.0;
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
	if is_playing:
		play(play_from_position);
		print("Playing music : " + name)

## Play the music instance..
func play(from_position:float = 0.0) -> void:
	is_playing = true;
	play_from_position = from_position;
	if is_node_ready():
		my_stream_player.play(play_from_position)
	

## This will set the volume relative to THIS music instance full volume.
## Change the music instance's max volume -> "max_volume".
func set_volume_linear(linear_vol:float) -> void:	
	current_linear_volume = linear_vol;
	my_stream_player.volume_linear = lerp(0.0, max_volume, current_linear_volume);

func _process(_delta: float) -> void:
	set_volume_linear(current_linear_volume);

## Pause the music instance.
func pause_music(is_paused_enabled:bool):
	my_stream_player.stream_paused = is_paused_enabled;
	
func is_paused() -> bool:
	return my_stream_player.stream_paused;
	
## Stop the music instance and queue it to be freed and deleted.
func stop_music():
	is_playing = false;
	if is_node_ready():
		my_stream_player.stop();

## terminate this music and queue it up for deletion
func terminate_music():
	queue_free();

## Fades out the music in the duration determined by the "duration" argument.
## [b]Optional[/b] by passing a [b]callback[/b] this will fire oncce it fully fades out
func fade_out_music(duration:float = 2.0, callback:Callable = Callable()):
	if my_fadeout_tween and my_fadeout_tween.is_valid():
		my_fadeout_tween.kill();
		
	my_fadeout_tween = create_tween();
	my_fadeout_tween.tween_property(self, "current_linear_volume", 0.0, duration);
	my_fadeout_tween.tween_callback(func():
		if callback.is_valid():
			callback.call();
	)
				
## Fades in the music in the duration determined by the "duration" argument.
## [b]Optional[/b] by passing a [b]callback[/b] this will fire oncce it fully fades in
func fade_in_music(duration:float = 2.0, callback:Callable = Callable()):
	if my_fadeout_tween and my_fadeout_tween.is_valid():
		my_fadeout_tween.kill();
		
	my_fadeout_tween = create_tween();
	my_fadeout_tween.tween_property(self, "current_linear_volume", 1.0, duration);
	my_fadeout_tween.tween_callback(func():
		if callback.is_valid():
			callback.call();
	)
