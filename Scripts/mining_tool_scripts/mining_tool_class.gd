extends Node2D
class_name MINING_TOOL

enum states{held,stashed,using,unequipped}
var state:states

@export_group("Essential Nodes")
@export var tool_owner:PLAYER
@export var anim:AnimatedSprite2D


@export var ray_cast: RayCast2D
@export var collider_ray: RayCast2D

var rays:Array[RayCast2D]
var rays_target_pos:Array[Vector2]
var rays_default_pos:Array[Vector2]

@export_group("Anim Positions")
@export var stashed_pos:Vector2 =  Vector2(-1,0)
@export var stashed_angle:float = 25
@export var held_pos:Vector2 = Vector2(25,0)

var ray_default_target:Vector2
var ray_default_pos:Vector2
var collider_default_target:Vector2
var collider_default_pos:Vector2

var stashed_z_index:int = -1

signal state_changed(prev:states,new:states)

func setup():
	rays.append_array([ray_cast,collider_ray])
	for ray in rays:
		rays_target_pos.push_back(ray.target_position)
		rays_default_pos.push_back(ray.position)
	state = states.stashed
	stash()
	


func equip(new:states):
	if(new == states.using or new == states.held):
		take_out()
	change_state(new)

func unequip():
	stash()
	change_state(states.unequipped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_tool(delta)
	handle_collider_ray(delta)
	pass


func handle_collider_ray(delta:float):
	var lerp_mult:float = 2
	if(state == states.stashed or state == states.unequipped):
		position = Vector2.ZERO
		return
	var target_pos:Vector2 = position
	if (collider_ray.is_colliding()):
		#var tip_pos = ray_cast.to_global(ray_cast.target_position)
		var tip_pos = to_global(Vector2.ZERO)
		var dir:Vector2 = collider_ray.get_collision_point().direction_to(tip_pos)
		var dist:float = collider_ray.get_collision_point().distance_to(tip_pos)
		target_pos = Vector2(-1,-1) + dir*dist*0.8
		lerp_mult = 5
	else:
		if(!ray_cast.is_colliding() and !collider_ray.is_colliding()):
			target_pos = Vector2.ZERO
	position = lerp(position,target_pos,lerp_mult*delta)

func flip_ray(flip:bool):
	var sign:int = 1
	if(flip):
		sign = -1
	for i in rays.size():
		rays[i].position.y = rays_default_pos[i].y * sign
		rays[i].target_position.y = rays_target_pos[i].y * sign

var stopped_dir:Vector2
func handle_tool(delta:float):
	if(state == states.unequipped):
		stash()
		return
	if(state != states.stashed):
		var dir:float = tool_owner.global_position.angle_to_point(get_global_mouse_position())
		dir = fposmod(snappedf(dir,PI/8),TAU)
		rotation = lerp_angle(rotation,dir,5*delta)
		
		if(cos(rotation)<0):
			anim.flip_v = true
			flip_ray(true)
		else:
			anim.flip_v = false
			flip_ray(false)
	
	else:
		stash()
	
	if(Input.is_action_just_pressed("GRAB_TOOL")):
		if(state == states.stashed):
			change_state(states.held)
			take_out()
		elif(state == states.held):
			change_state(states.stashed)
			stash()
	elif(Input.is_action_pressed("USE_TOOL")):
		if(state == states.held and tool_owner.state == tool_owner.STATES.IDLE):
			change_state(states.using)
	elif(
		Input.is_action_just_released("USE_TOOL")
		and !Input.is_action_pressed("USE_TOOL")
		and state == states.using
		):
		change_state(states.held)
		
	elif(state == states.using and tool_owner.state != tool_owner.STATES.IDLE):
		change_state(states.held)
		state = states.held


func change_state(new:states):
	state_changed.emit(state,new)
	state = new
	


func take_out():
	z_index = 0
	anim.flip_v = false
	anim.global_rotation_degrees = 0
	anim.position = held_pos


func stash():
	rotation_degrees = 0
	z_index = stashed_z_index
	anim.flip_v = false
	anim.position = stashed_pos
	
	anim.global_rotation_degrees = stashed_angle
	
	if(tool_owner.anim and tool_owner.anim.flip_h):
		anim.global_rotation_degrees = 180-stashed_angle
		anim.position.x = -1*stashed_pos.x
		anim.flip_v = true
	pass
