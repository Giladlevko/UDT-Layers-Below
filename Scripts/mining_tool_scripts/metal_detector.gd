extends MINING_TOOL
class_name METAL_DETECTOR
@onready var gem_collider: RayCast2D = $AnimatedSprite2D/rays/gem_collider
@onready var beep_timer: Timer = $beep_timer
var beep_freq:float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.setup()
	self.state_changed.connect(on_state_changed)
	change_state(states.unequipped)
	SignalBus.detector_range_changed.connect(on_detector_range_changed)
	pass # Replace with function body.

func on_detector_range_changed():
	gem_collider.target_position.x = Global.detactor_range
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.handle_tool(delta)
	self.handle_collider_ray(delta)
	handle_gem_collider()
	pass


func on_state_changed(prev:states,new:states):
	if(prev == states.using and new == states.held):
		stop()
	elif(prev == states.held and new == states.using):
		detect()
	elif(prev == states.unequipped and new == states.using):
		detect()
	elif(prev == states.using and new == states.unequipped):
		stop()
	pass

var can_beep:bool = true
func beep():
	if(can_beep):
		can_beep = false
		beep_timer.start(beep_freq)
		

func handle_gem_collider():
	if gem_collider.is_colliding():
		beep()
		var col_pos:Vector2 = gem_collider.get_collision_point()
		var dist = global_position.distance_to(col_pos)
		var sec_per_pixel:float = 0.005
		beep_freq = clamp(sec_per_pixel*dist,sec_per_pixel,3)
		pass

func detect():
	anim.play("detect")
	gem_collider.enabled = true

func stop():
	anim.stop()
	anim.frame = 0
	gem_collider.enabled = false

func _on_beep_timer_timeout() -> void:
	can_beep = true
	if(gem_collider.is_colliding()):
		#sfx here
		UI_GLOBAL.button_hover_sfx.play()
	pass # Replace with function body.
