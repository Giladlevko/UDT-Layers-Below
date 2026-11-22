extends CharacterBody2D
class_name CryingMan

enum states{crying,speaking}
var state:states = states.crying
var skeletons_found:bool = false
@export_range(-1,1,2) var dir_x:int
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.puzzle_solved.connect(on_puzzle_solved)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	if(!is_on_floor()):velocity.y += 300*delta
	if(state == states.speaking):
		var dir:Vector2 = global_position.direction_to(Global.player.global_position)
		anim.flip_h = dir.x<0
		anim.play("speaking")
	elif(state == states.crying):
		anim.play("crying")
		anim.flip_h = (dir_x < 0)
	pass


func on_puzzle_solved():
	skeletons_found = true
	can_speak = true
	state = states.speaking
	pass

var can_speak:bool = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER and can_speak:
		can_speak = false
		state = states.speaking
		var dialog_to_play:String
		if(skeletons_found):
			dialog_to_play = "found_skeletons"
		else:
			dialog_to_play = "find_skeletons"
		UI_GLOBAL.text_box.dialog_data = Global.npc_dialog_data
		UI_GLOBAL.text_box.play_dialog(dialog_to_play)
		await SignalBus.dialog_ended
		if(skeletons_found):
			state = states.speaking
		else:
			state = states.crying
	pass # Replace with function body.
