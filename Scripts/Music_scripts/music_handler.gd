extends Node

## This is like a music player manager that handles multiple playing music instances.
class_name MusicHandler


@export var _music_dictionary:Dictionary[StringName, PackedScene]

var music_title:MUS_Title;
var music_credits:MUS_Base
var music_options:MUS_Base
var music_gameplay:MUS_Gameplay;
var queue_ready_function:Callable;
var has_ready_function_queued:bool = false;


var is_currently_paused:bool = false;
var my_menu_paused:PauseMenu;
var my_menu_main:MenuUI;

func music_debug_print(msg:String):
	print("Music Debug - ", msg);

func music_debug_printerr(msg:String):
	printerr("Music ERROR - ", msg);

func set_music_paused(is_paused:bool):
	if (is_currently_paused == is_paused):
		return;
		
	is_currently_paused = is_paused;
		
	if (is_currently_paused):
		music_gameplay.pause_music(true);
		music_options.set_volume_linear(0.0);
		music_options.fade_in_music(20.0);
		music_options.play();
	else:
		music_gameplay.set_volume_linear(1.0);
		music_gameplay.pause_music(false);
		music_options.stop_music();	
		
func on_back_to_main_menu():
	music_debug_print("Going back to main menu")
	set_music_paused(false);
	music_gameplay.stop_music();
	music_options.fade_out_music(2.0, func():			
		music_options.stop_music();
		music_title.play();
		music_title.set_volume_linear(1.0);
		music_debug_print("Play menu music again")
	)
	
	
func _ready() -> void:
	music_title = add_music("BGM_Title");
	music_gameplay = add_music("BGM_Gameplay");
	music_options = add_music("BGM_Options");
	
	music_title.play();
	
	
	if has_ready_function_queued:
		queue_ready_function.call();
		has_ready_function_queued = false;

	
func on_main_menu_switch_to_settings():
	music_title.switch_to_settings();

func on_main_menu_switch_to_main():
	music_title.switch_to_main();
	

func on_pause_visibility_changed():
	set_music_paused(my_menu_paused.visible);
	
func set_pause_menu(pause_menu:PauseMenu):
	#self.buttons = [resume_button,inv_button,back_to_main_button,audio_button,store_button]
	my_menu_paused = pause_menu;
	my_menu_paused.visibility_changed.connect(on_pause_visibility_changed);
	
	var back_to_main_menu_button:Button = my_menu_paused.buttons.get(2);
	
	if back_to_main_menu_button:
		back_to_main_menu_button.pressed.connect(on_back_to_main_menu);
	
func set_main_menu(main_menu:MenuUI):
	#buttons = [play_button,audio_button,credits_button,quit_button,help_button]
	my_menu_main = main_menu;
	
	var main_menu_play_button:Button = my_menu_main.buttons.get(0);
	var main_menu_audio_settings_button:Button = my_menu_main.buttons.get(1);
	var main_menu_credits_button:Button = my_menu_main.buttons.get(2);
	var back_to_menu_from_settings_button:Button = my_menu_main.get_node("Panel/MarginContainer/audio_controler/Panel/button_cont/close_button");
	
	if main_menu_credits_button:
		main_menu_credits_button.pressed.connect(on_main_menu_on_credits_enter);
		
	if back_to_menu_from_settings_button:
		back_to_menu_from_settings_button.pressed.connect(on_main_menu_switch_to_main);
		
	if main_menu_play_button:
		main_menu_play_button.pressed.connect(on_main_menu_play);
		
	if main_menu_audio_settings_button:
		main_menu_audio_settings_button.pressed.connect(on_main_menu_switch_to_settings)
	
func on_main_menu_on_credits_exit():
	music_title.fade_in_music(2.0);
	var old_credits_music:MUS_Base = Music_GLOBAL.music_credits;
	music_credits = null;
	old_credits_music.fade_out_music(2.0, func():
		old_credits_music.terminate_music();
	)
	
func on_main_menu_on_credits_enter():
	music_credits = add_music("BGM_Credits");
	music_credits.play();
	music_title.fade_out_music(2.0);
	
func on_main_menu_play():
	music_debug_print("Time to play!")
	music_title.fade_out_music(2.0);
	await get_tree().create_timer(2.0).timeout
	music_gameplay.set_volume_linear(0.0);
	music_gameplay.fade_in_music(4.0);
	music_gameplay.play();
	music_gameplay.pause_music(is_currently_paused);




## Once the music is added it will begin playing
## The music instance will be also added to the pool of children
func add_music(music_name:StringName) -> MUS_Base:
	var packedScene:PackedScene = _music_dictionary.get(music_name);	
	if packedScene == null:
		music_debug_printerr("Could not find music name " + music_name)
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
