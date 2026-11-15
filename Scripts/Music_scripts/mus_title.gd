extends MUS_Base

class_name MUS_Title

@export var sync_streams:Array[AudioStreamSynchronized]

var volume_linear_main:float = 1.0;
var volume_linear_settings:float = 0.0;
var my_tween:Tween;


func switch_to_settings():
	if my_tween:
		my_tween.kill();
	
	my_tween = create_tween();
	my_tween.set_parallel(true);
	my_tween.tween_property(self, "volume_linear_main", 0.0, 1.0);
	my_tween.tween_property(self, "volume_linear_settings", 1.0, 1.0);

func switch_to_main():
	if my_tween:
		my_tween.kill();
	
	my_tween = create_tween();
	my_tween.set_parallel(true);
	my_tween.tween_property(self, "volume_linear_main", 1.0, 1.0);
	my_tween.tween_property(self, "volume_linear_settings", 0.0, 1.0);

func _process(delta: float) -> void:
	super._process(delta);
	for sync_stream:AudioStreamSynchronized in sync_streams:
		sync_stream.set_sync_stream_volume(0, linear_to_db(volume_linear_main));	
		sync_stream.set_sync_stream_volume(1, linear_to_db(volume_linear_settings));	
