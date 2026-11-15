extends Node2D
class_name JACK_HAMMER
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var drill_coli: CollisionShape2D = $AnimatedSprite2D/Area2D/CollisionShape2D
enum states{held,stashed,drilling}
var state:states
@export var drill_owner:PLAYER

var stashed_pos:Vector2 =  Vector2(-1,0)
var stashed_angle:float = 25

var held_pos:Vector2 = Vector2(15,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	pass # Replace with function body.


func setup():
	state = states.stashed
	stash()
	anim.speed_scale = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_drill()
	
	pass



func handle_drill():
	if(state != states.stashed):
		look_at(get_global_mouse_position())
		anim.flip_v = cos(rotation)<0
	
	else:
		stash()
	
	if(Input.is_action_just_pressed("GRAB_DRILL")):
		if(state == states.stashed):
			state = states.held
			take_out()
		elif(state == states.held):
			state = states.stashed
	elif(Input.is_action_just_pressed("DRILL")):
		if(state == states.held and drill_owner.state == drill_owner.STATES.IDLE):
			state = states.drilling
			drill()
	elif(Input.is_action_just_released("DRILL") and state == states.drilling):
		state = states.held
		stop()
		
	elif(state == states.drilling and drill_owner.state != drill_owner.STATES.IDLE):
		state = states.held
		stop()


func take_out():
	z_index = 0
	anim.flip_v = false
	anim.global_rotation_degrees = 0
	anim.position = held_pos

func stash():
	rotation_degrees = 0
	z_index = -1
	anim.flip_v = false
	anim.position = stashed_pos
	anim.global_rotation_degrees = stashed_angle
	if(drill_owner.anim and drill_owner.anim.flip_h):
		anim.global_rotation_degrees = 180-stashed_angle
		anim.position.x = -1*stashed_pos.x
		anim.flip_v = true
	pass

var drill_tween:Tween
func drill():
	if(stop_tween):stop_tween.kill()
	drill_tween = create_tween()
	const dur:float = 1.5
	anim.play("drill")
	drill_tween.tween_property(anim,"speed_scale",1,dur)
	drill_coli.set_deferred("disabled",false)
	await drill_tween.finished
	drill_tween.kill()

var stop_tween:Tween
func stop():
	if(drill_tween):drill_tween.kill()
	stop_tween = create_tween()
	const dur:float = 1
	stop_tween.tween_property(anim,"speed_scale",0,dur)
	await stop_tween.finished
	anim.stop()
	anim.frame = 0
	drill_coli.set_deferred("disabled",true)
	stop_tween.kill()
	
