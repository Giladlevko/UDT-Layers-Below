extends Node2D
class_name Mushroom

@export_range(-1,1,2) var dir_x:int = -1
var base_pos:Vector2
@onready var confetti_particles: ConfettiParticles = $confetti_particles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func push():
	var tween:=create_tween()
	var new_pos:Vector2 = base_pos + Vector2(10*dir_x,0)
	confetti_particles.rotation_degrees = -90*dir_x
	tween.tween_property(self,"global_position",new_pos,1.5)
	await tween.finished
	confetti_particles.emit()
	await get_tree().create_timer(1).timeout
	SignalBus.puzzle_solved.emit()
	pass
