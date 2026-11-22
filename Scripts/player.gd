extends CharacterBody2D
class_name PLAYER

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var colli: CollisionShape2D = $CollisionShape2D
@onready var cam: PLAYER_CAM = $Camera2D

@onready var walk_sfx: AudioStreamPlayer2D = $sfx/walk_sfx
@onready var jump_sfx: AudioStreamPlayer2D = $sfx/jump_sfx

@onready var flash_light: PointLight2D = $FlashLight

var jack_hammer: JACK_HAMMER
var metal_detector: METAL_DETECTOR

var mining_tools:Array[MINING_TOOL] = []

enum STATES{IDLE,RUNNING,JUMP,DASH,FROZEN,PUSHED}
var state:STATES
var can_dash:bool = true
const SPEED:int = 150


@export var jump_height:float = 45
@export var jump_time_to_peak:float = 0.35
@export var jump_time_to_descent: float = 0.3
@onready var JUMP_VELOCITY = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = ((-2 * jump_height) / (jump_time_to_peak * jump_time_to_peak))*-1
@onready var fall_gravity:float  =  ((-2 * jump_height) / (jump_time_to_descent * jump_time_to_descent))*-1
@onready var walk_particles: CPUParticles2D = $walk_particles



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player = self
	enter_state(STATES.IDLE)
	flash_light.texture_scale = Global.vision_range
	SignalBus.on_item_taken.connect(on_inv_item_taken)
	SignalBus.vision_range_changed.connect(on_vision_changed)
	SignalBus.dialog_started.connect(on_dialog_start)
	SignalBus.dialog_ended.connect(on_dialog_end)
	SignalBus.puzzle_solved.connect(on_puzzle_solved)
	
	SignalBus.on_take_item.emit.call_deferred(Global.drill_slot_data)
	#SignalBus.on_take_item.emit(Global.metal_detector_slot_data)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		STATES.RUNNING:move_state(delta)
		STATES.IDLE:idle_state(delta)
		STATES.PUSHED:pushed_state(delta)
		STATES.DASH:dash_state(delta)
		STATES.JUMP:jump_state()
	constant_state(delta)
	
	if(Input.is_action_just_pressed("SWITCH_TOOL")):
		switch_tool()

var current_tool_index = 0
func switch_tool():
	if mining_tools.is_empty():return
	var next_index:int = (current_tool_index + 1) % mining_tools.size()
	if(next_index == current_tool_index):return
	
	var current_tool_state: = mining_tools[current_tool_index].state
	mining_tools[next_index].equip(current_tool_state)
	mining_tools[next_index].stashed_z_index = -1
	mining_tools[current_tool_index].unequip()
	mining_tools[current_tool_index].stashed_z_index = -2
	current_tool_index = next_index
	pass

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

func idle_state(delta:float):
	velocity.x = lerpf(velocity.x,0,10*delta)
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
		pass
		#change_state(STATES.DASH)
	pass

func move_state(delta:float):
	var dir_x = Input.get_axis("LEFT","RIGHT")
	velocity.x = dir_x * SPEED
	if(!is_on_wall()):
		walk_particles.emitting = true
	else:
		walk_particles.emitting = false
	
	if (!movement_pressed()):
		change_state(STATES.IDLE)
	
	if(Input.is_action_just_pressed("DASH") and can_dash):
		pass
		#change_state(STATES.DASH)
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


func pushed_state(delta:float):
	if(is_on_floor() and velocity.x < 0.2):
		change_state(STATES.IDLE)
	velocity.x = lerpf(velocity.x,0,10*delta)

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
	walk_particles.initial_velocity_max = 1*sign(dir_x)*40
	walk_particles.initial_velocity_min = 1*sign(dir_x)*40
	



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
		STATES.PUSHED:
			anim.play("idle")
		STATES.FROZEN:
			anim.play("idle")
			velocity.x = 0
		STATES.IDLE:
			anim.play("idle")
			pass
		STATES.RUNNING:
			#walk_particles.emitting = true
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
			jump_sfx.play()
			anim.play("jump")
			velocity.y += JUMP_VELOCITY
##function for handleing state exits
func exit_state(state_name):
	match state_name:
		STATES.RUNNING:
			walk_particles.emitting = false
		pass


func already_has_tool(tool:MINING_TOOL)->bool:
	var tool_name:String = tool.get_script().get_global_name()
	for t in mining_tools:
		if t.get_script().get_global_name() == tool_name:
			return true
	return false

func on_inv_item_taken(successful:bool,data:InvSlotData):
	if((data.slot_type == "Tool" or data.name == "Water Canteen") and successful):
		var new_tool:MINING_TOOL = data.scene.instantiate()
		if(already_has_tool(new_tool)):
			new_tool.queue_free()
			return
		new_tool.tool_owner = self
		add_child(new_tool)
		new_tool.global_position = global_position
		mining_tools.push_back(new_tool)
		if new_tool is JACK_HAMMER:
			jack_hammer = new_tool
		elif new_tool is METAL_DETECTOR:
			metal_detector = new_tool
			
		switch_tool()
	


func on_vision_changed():
	flash_light.texture_scale = Global.vision_range


func _on_animated_sprite_2d_animation_looped() -> void:
	pass


func _on_animated_sprite_2d_frame_changed() -> void:
	if anim.animation == "run":
		if anim.frame == 2:
			walk_sfx.play()
	pass # Replace with function body.

func on_dialog_start(dialog_name:String):
	change_state(STATES.FROZEN)
	cam.pan_down()
	

func on_dialog_end(dialog_name:String):
	change_state(STATES.IDLE)
	cam.pan_up()


func push(force:Vector2):
	change_state(STATES.PUSHED)
	velocity = force



func on_puzzle_solved():
	change_state(STATES.FROZEN)
	cam.pan_to_exit()
	await SignalBus.cam_pan_finished
	change_state(STATES.IDLE)
