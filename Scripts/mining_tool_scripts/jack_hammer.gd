extends MINING_TOOL
class_name JACK_HAMMER


@onready var tile_particle: CPUParticles2D = $particles/tile_particle
@onready var drill_ray: RayCast2D = $AnimatedSprite2D/drill_ray

@onready var using_sfx: AudioStreamPlayer2D = $sfx/using_sfx


var damage:int = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.rays.push_back(drill_ray)
	self.setup()
	anim.speed_scale = 0
	state_changed.connect(on_state_changed)
	SignalBus.emit_tile_particle.connect(emit_tile_particle)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.handle_tool(delta)
	self.handle_collider_ray(delta)
	pass



func on_state_changed(prev:states,new:states):
	if(prev == states.using and new == states.held):
		stop()
	elif(prev == states.held and new == states.using):
		drill()
	elif(prev == states.unequipped and new == states.using):
		drill()
	elif(prev == states.using and new == states.unequipped):
		stop()
	pass


var drill_tween:Tween
func drill():
	if(stop_tween):stop_tween.kill()
	anim.play("drill")
	if(anim.speed_scale < 1):
		drill_tween = create_tween()
		const dur:float = 1.5
		drill_ray.enabled = true
		drill_tween.tween_property(anim,"speed_scale",Global.drill_speed,dur)
		await drill_tween.finished
		drill_tween.kill()

var stop_tween:Tween
func stop():
	if(drill_tween):drill_tween.kill()
	stop_tween = create_tween()
	const dur:float = 1
	drill_ray.enabled = false
	stop_tween.tween_property(anim,"speed_scale",0,dur)
	await stop_tween.finished
	anim.stop()
	anim.frame = 0
	stop_tween.kill()
	

var curr_collider:TILE_HIT_BOX
func _on_animated_sprite_2d_animation_looped() -> void:
	using_sfx.play()
	if(drill_ray.enabled):
		var collider = drill_ray.get_collider()
		curr_collider = collider
		if(collider is TILE_HIT_BOX):
			collider.take_damage(Global.drill_power)
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
	
