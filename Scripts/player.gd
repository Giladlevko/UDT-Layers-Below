extends CharacterBody2D
class_name PLAYER

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var colli: CollisionShape2D = $CollisionShape2D
@onready var jack_hammer: JACK_HAMMER = $jack_hammer

enum STATES{IDLE,RUNNING,JUMP,DASH}
var state:STATES
var can_dash:bool = true
const SPEED:int = 150


@export var jump_height:float = 45
@export var jump_time_to_peak:float = 0.35
@export var jump_time_to_descent: float = 0.3
@onready var JUMP_VELOCITY = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = ((-2 * jump_height) / (jump_time_to_peak * jump_time_to_peak))*-1
@onready var fall_gravity:float  =  ((-2 * jump_height) / (jump_time_to_descent * jump_time_to_descent))*-1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_state(STATES.IDLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		STATES.RUNNING:move_state()
		STATES.IDLE:idle_state()
		STATES.DASH:dash_state(delta)
		STATES.JUMP:jump_state()
	pass
	constant_state(delta)


func get_grav() -> float:
	return jump_gravity if velocity.y < 0 else fall_gravity

func movement_pressed()->bool:
	return (
		Input.is_action_pressed("LEFT")
		 and 
		!Input.is_action_pressed("RIGHT")
		or
		Input.is_action_pressed("RIGHT")
		and
		!Input.is_action_pressed("LEFT")
		)

func idle_state():
	velocity.x = 0
	if(movement_pressed()):
		change_state(STATES.RUNNING)
	if(Input.is_action_just_pressed("JUMP")):
		change_state(STATES.JUMP)
	pass

func jump_state():
	var dir_x = Input.get_axis("LEFT","RIGHT")
	velocity.x = dir_x * SPEED
	if(is_on_floor()):
		if(dir_x != 0):
			change_state(STATES.RUNNING)
		else:change_state(STATES.IDLE)
	if(Input.is_action_just_pressed("DASH") and can_dash):
		change_state(STATES.DASH)
	pass

func move_state():
	var dir_x = Input.get_axis("LEFT","RIGHT")
	velocity.x = dir_x * SPEED
	
	if (!movement_pressed()):
		change_state(STATES.IDLE)
	
	if(Input.is_action_just_pressed("DASH") and can_dash):
		change_state(STATES.DASH)
	if(Input.is_action_just_pressed("JUMP") and can_jump()):
		change_state(STATES.JUMP)
	pass

var in_coyote_time:bool = false

func can_jump()->bool:
	return is_on_floor() || in_coyote_time

func dash_state(delta:float):
	const DASH_POWER:int = 25 * SPEED
	var dir_x = Input.get_axis("LEFT","RIGHT")
	velocity.x += DASH_POWER*dir_x*delta
	
	pass

func start_coyote():
	in_coyote_time = true
	can_coyote = false
	var dur = 0.08
	await get_tree().create_timer(dur).timeout
	in_coyote_time = false

var can_coyote:bool = true

func constant_state(delta:float):
	move_and_slide()
	if(!is_on_floor()):
		if(can_coyote):
			start_coyote() 
		if(!in_coyote_time || state == STATES.JUMP):
			velocity.y += get_grav() * delta
	else:
		can_coyote = true
	var dir_x = Input.get_axis("LEFT","RIGHT")
	if(dir_x != 0):
		anim.flip_h = (dir_x == -1)
	


var changing_state:bool = false
func change_state(next:STATES,prev:STATES = state):
	if !changing_state and state != next:
		changing_state = true
		state = next
		exit_state(prev)
		enter_state(next)
		set_deferred("changing_state",false)

##function for handleing state entries
func enter_state(state_name:STATES):
	match state_name:
		STATES.IDLE:
			anim.play("idle")
			pass
		STATES.RUNNING:
			anim.play("run")
			pass
		STATES.DASH:
			const DASH_TIME = 0.2
			can_dash = false
			await get_tree().create_timer(DASH_TIME).timeout
			change_state(STATES.RUNNING)
			const dash_cooldown:float = 1.2
			SignalBus.start_cooldown.emit(dash_cooldown)
			await SignalBus.cooldown_ended
			can_dash = true
		STATES.JUMP:
			anim.play("jump")
			velocity.y += JUMP_VELOCITY
##function for handleing state exits
func exit_state(state_name):
	match state_name:
		pass


func _on_animated_sprite_2d_animation_looped() -> void:
	pass


func _on_animated_sprite_2d_animation_changed() -> void:
	if(jack_hammer.state == jack_hammer.states.stashed):
		if(anim.animation == "run"):
			pass
		else:
			pass
	pass # Replace with function body.
