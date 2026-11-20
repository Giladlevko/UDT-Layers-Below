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

# MAIN MENU
const MENU_MAIN_MARGIN_PATH:NodePath = "../MainMenue/Panel/MarginContainer";
const MENU_AUDIO_CLOSE_BUTTON_PATH:NodePath = "audio_controler/Panel/button_cont/close_button";
const MENU_AUDIO_BUTTON_PATH:NodePath = "VBoxContainer/buttons_container/audio_button";
const MENU_PLAY_BUTTON_PATH:NodePath = "VBoxContainer/buttons_container/play_button";
const MENU_CREDITS_BUTTON_PATH:NodePath = "VBoxContainer/buttons_container/credits_button";

var is_currently_paused:bool = false;


func _process(delta: float) -> void:
	var is_paused = get_tree().paused;
	if (is_currently_paused == is_paused):
		return;
	
	is_currently_paused = is_paused;
	if (is_currently_paused):
		music_gameplay.pause_music(true);
		music_options.set_volume_linear(0.0);
		music_options.fade_in_music(20.0);
		music_options.play();
	else:
		music_gameplay.pause_music(false);
		music_options.stop_music();
		
	
func _ready() -> void:
	music_title = add_music("BGM_Title");
	music_gameplay = add_music("BGM_Gameplay");
	music_options = add_music("BGM_Options");
	
	if has_ready_function_queued:
		queue_ready_function.call();
		has_ready_function_queued = false;

	
func _main_menu_switch_to_settings():
	music_title.switch_to_settings();

func _main_menu_switch_to_main():
	music_title.switch_to_main();
	
func _main_menu_on_credits_exit():
	pass;
	#music_title.fade_in_music(2.0);
	#var old_credits_music:MUS_Base = Music_GLOBAL.music_credits;
	#music_credits = null;
	#old_credits_music.fade_out_music(2.0, func():
		#old_credits_music.terminate_music();
	#)
	
func _main_menu_on_credits_enter():
	pass;
	#music_credits = add_music("BGM_Credits");
	#music_credits.play();
	#music_title.fade_out_music(2.0);
	
func _main_menu_play():
	music_title.fade_out_music(2.0);
	await get_tree().create_timer(2.0).timeout	
	music_gameplay.set_volume_linear(0.0);
	music_gameplay.fade_in_music(4.0);
	music_gameplay.play();

func _enter_menu_tree():
	music_title.play();
	var menu_margin:MarginContainer = get_node(MENU_MAIN_MARGIN_PATH);	
	var menu_audio_button:Button = menu_margin.get_node(MENU_AUDIO_BUTTON_PATH)
	var menu_audio_close_button:Button = menu_margin.get_node(MENU_AUDIO_CLOSE_BUTTON_PATH);
	var menu_play_button:Button = menu_margin.get_node(MENU_PLAY_BUTTON_PATH);
	var menu_credits_button:Button = menu_margin.get_node(MENU_CREDITS_BUTTON_PATH);
	
	menu_audio_button.pressed.connect(_main_menu_switch_to_settings);	
	menu_audio_close_button.pressed.connect(_main_menu_switch_to_main)
	menu_play_button.pressed.connect(_main_menu_play)
	menu_credits_button.pressed.connect(_main_menu_on_credits_enter)
		

func _enter_tree() -> void:
	var scene_tree:SceneTree = self.get_tree();
	print("Current Scene : " + scene_tree.current_scene.name)
	if (scene_tree.current_scene.name == "MainMenue"):
		queue_ready_function =  _enter_menu_tree;
		
	if (is_node_ready()):
		queue_ready_function.call();
	else:
		has_ready_function_queued = true;


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
