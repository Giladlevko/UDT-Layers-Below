extends Camera2D
class_name PLAYER_CAM
var default_max_shake:float = 5
var shake_strength:float = 0.0
var shake_fade = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if shake_strength>0.0:
		offset = random_offset()
		shake_strength = lerpf(shake_strength,0.0,shake_fade*delta)
	#admouse_offset(delta)

func shake(max_shake:float = default_max_shake):
	shake_strength = max_shake

func random_offset():
	var rand_x: = randf_range(-shake_strength,shake_strength)
	var rand_y: = randf_range(-shake_strength,shake_strength)
	return Vector2(rand_x,rand_y)

var pan_offset:int = 50
func pan_down():
	position.y = pan_offset

func pan_up():
	position.y = -1*pan_offset


func pan_to_exit():
	var tween:=create_tween().set_trans(Tween.TRANS_CUBIC)
	var target_pos:Vector2 = Global.exit_door.global_position
	var dist:float = global_position.distance_to(target_pos)
	var dur:float = dist / 300
	tween.tween_property(self,"global_position",(target_pos),dur)
	position_smoothing_enabled = false
	tween.tween_callback(reached_target)
	tween.tween_interval(2)
	tween.tween_property(self,"global_position",get_parent().global_position,dur)
	await tween.finished
	SignalBus.cam_pan_finished.emit()
	position_smoothing_enabled = true
	position = Vector2.ZERO
	
	

func reached_target():
	SignalBus.open_exit.emit()
	pass
