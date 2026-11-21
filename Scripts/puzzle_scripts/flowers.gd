extends Node2D
class_name FLOWER
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var confetti_particles: ConfettiParticles = $confetti_particles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

var bloomed:bool = false
func bloom():
	if !bloomed:
		bloomed = true
		anim.play("bloom")
		await anim.animation_finished
		confetti_particles.emit()
		await get_tree().create_timer(1).timeout
		SignalBus.puzzle_solved.emit()
