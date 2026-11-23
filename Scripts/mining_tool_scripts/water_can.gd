extends MINING_TOOL
class_name WATER_CAN
@onready var water_particles: CPUParticles2D = $AnimatedSprite2D/CPUParticles2D
@onready var water_ray: RayCast2D = $AnimatedSprite2D/water_ray


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.state_changed.connect(on_state_changed)
	self.setup()
	change_state(states.unequipped)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.handle_collider_ray(delta)
	self.handle_tool(delta)
	if(state == states.using):
		anim.flip_v = true
	else:
		anim.flip_v = false
	pass
	
	if(water_ray.is_colliding() and state == states.using):
		var collider:Area2D = water_ray.get_collider()
		var parent:Node2D = collider.get_parent()
		if parent is FLOWER:
			parent.bloom()

func on_state_changed(prev:states,new:states):
	if(prev == states.held and new == states.using):
		water_on()
	elif(prev == states.using and new == states.held):
		water_off()
	pass


func water_on():
	water_particles.emitting = true

func water_off():
	water_particles.emitting = false
