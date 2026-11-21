extends UI
class_name InteractPopup
enum states{on,off}
var state:states = states.off

signal interacted
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pop_off()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func popup():
	state = states.on
	tween_visibility(self,true)

func pop_off():
	state = states.off
	tween_visibility(self,false)

func _input(event: InputEvent) -> void:
	if(Input.is_action_just_pressed("interact") and state == states.on):
		interacted.emit()
		pop_off()
