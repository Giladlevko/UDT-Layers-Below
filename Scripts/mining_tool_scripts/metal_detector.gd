extends MINING_TOOL


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.setup()
	state_changed.connect(on_state_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.handle_tool(delta)
	self.handle_collider_ray(delta)
	pass


func on_state_changed(prev:states,new:states):
	pass
