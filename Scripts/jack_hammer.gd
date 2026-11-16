extends Node2D
class_name JACK_HAMMER
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum states{held,stashed,drilling}
var state:states

@export var drill_owner:PLAYER



@onready var tile_particle: CPUParticles2D = $particles/tile_particle

@onready var collider_ray: RayCast2D = $AnimatedSprite2D/collider_ray

var stashed_pos:Vector2 =  Vector2(-1,0)
var stashed_angle:float = 25

@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D

var held_pos:Vector2 = Vector2(25,0)

var damage:int = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	SignalBus.emit_tile_particle.connect(emit_tile_particle)
	pass # Replace with function body.


func setup():
	state = states.stashed
	stash()
	anim.speed_scale = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_drill(delta)
	handle_collider_ray(delta)
	pass


func handle_collider_ray(delta:float):
	if(state == states.stashed):
		position = Vector2.ZERO
		return
	var target_pos:Vector2 = position
	if (collider_ray.is_colliding()):
		var tip_pos = ray_cast.to_global(ray_cast.target_position)
		#var tip_pos = to_global(Vector2.ZERO)
		var dir:Vector2 = collider_ray.get_collision_point().direction_to(tip_pos)
		var dist:float = collider_ray.get_collision_point().distance_to(tip_pos)
		target_pos = Vector2(-1,-1) - dir*dist*1.5
	else:
		if(!ray_cast.is_colliding() and !collider_ray.is_colliding()):
			target_pos = Vector2.ZERO
	position = lerp(position,target_pos,2*delta)


var stopped_dir:Vector2
func handle_drill(delta:float):
	if(state != states.stashed):
		var dir:float = drill_owner.global_position.angle_to_point(get_global_mouse_position())
		dir = fposmod(snappedf(dir,PI/8),TAU)
		rotation = lerp_angle(rotation,dir,5*delta)
		anim.flip_v = cos(rotation)<0
	
	else:
		stash()
	
	if(Input.is_action_just_pressed("GRAB_DRILL")):
		if(state == states.stashed):
			state = states.held
			take_out()
		elif(state == states.held):
			state = states.stashed
			stash()
	elif(Input.is_action_pressed("DRILL")):
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
	anim.play("drill")
	if(anim.speed_scale < 1):
		drill_tween = create_tween()
		const dur:float = 1.5
		ray_cast.enabled = true
		drill_tween.tween_property(anim,"speed_scale",1,dur)
		await drill_tween.finished
		drill_tween.kill()

var stop_tween:Tween
func stop():
	if(drill_tween):drill_tween.kill()
	stop_tween = create_tween()
	const dur:float = 1
	ray_cast.enabled = false
	stop_tween.tween_property(anim,"speed_scale",0,dur)
	await stop_tween.finished
	anim.stop()
	anim.frame = 0
	stop_tween.kill()
	

var curr_collider:TILE_HIT_BOX
func _on_animated_sprite_2d_animation_looped() -> void:
	if(ray_cast.enabled):
		var collider = ray_cast.get_collider()
		curr_collider = collider
		if(collider is TILE_HIT_BOX):
			collider.take_damage(damage)
	pass # Replace with function body.

func emit_tile_particle(count:int = 16,color:Color = Color.DARK_GRAY):
	if tile_particle.emitting: return
	tile_particle.global_position = curr_collider.global_position
	tile_particle.color = color
	tile_particle.amount = count
	tile_particle.emitting = true
	await tile_particle.finished
	SignalBus.particle_finished.emit()
	pass
	
