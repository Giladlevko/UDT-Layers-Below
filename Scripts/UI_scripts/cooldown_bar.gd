@tool
extends UI
@export var bar: ProgressBar



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	SignalBus.start_cooldown.connect(cooldown)
	pass # Replace with function body.

func setup():
	modulate.a = 0
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cooldown(dur:float):
	tween_visibility(self,true)
	var tween:Tween = create_tween()
	tween.tween_property(bar,"value",bar.min_value,dur)
	await tween.finished
	SignalBus.cooldown_ended.emit()
	await tween_visibility(self,false)
	bar.value = bar.max_value
	
