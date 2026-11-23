extends CharacterBody2D
class_name GUARD
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var dialog:DialogData
@onready var area_coli: CollisionShape2D = $Area2D/CollisionShape2D


var dir:Vector2
enum states{LevelEND,LevelSTART}
var state:states = states.LevelSTART
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.cam_pan_finished.connect(on_cam_pan_finished)
	SignalBus.dialog_ended.connect(on_dialog_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	if(!is_on_floor()):velocity.y += 300
	dir = global_position.direction_to(Global.player.global_position)
	anim.flip_h = dir.x<0
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		UI_GLOBAL.text_box.dialog_data = dialog
		if(state == states.LevelEND):
			if(!Global.quota_reached):
				var versions_count = 3
				var r = Global.current_level_index
				UI_GLOBAL.text_box.play_dialog("give_me_coal"+str(r))
				await SignalBus.dialog_ended
				var d = sign(dir.x)
				body.push(Vector2(600*d,-100))
			else:
				var versions_count = 3
				var r = Global.current_level_index
				UI_GLOBAL.text_box.play_dialog("you_can_pass"+str(r))
				await SignalBus.dialog_ended
				SignalBus.level_finished.emit()
		elif(state == states.LevelSTART):
			UI_GLOBAL.text_box.play_dialog("intro"+str(Global.current_level_index))
			area_coli.set_deferred("disabled",true)

			pass
		pass


func on_cam_pan_finished():
	state = states.LevelEND
	global_position = Global.exit_door.guard_pos_node.global_position
	area_coli.set_deferred("disabled",false)
	pass


func on_dialog_end(dialog_name:String):
	if(dialog_name == "intro1"):
		SignalBus.on_take_item.emit(Global.drill_slot_data)
		SignalBus.coal_goal_changed.emit(100)
	elif(dialog_name == "intro2"):
		SignalBus.on_take_item.emit(Global.metal_detector_slot_data)
		SignalBus.coal_goal_changed.emit(150)
	elif(dialog_name == "intro3"):
		SignalBus.coal_goal_changed.emit(200)
	pass
