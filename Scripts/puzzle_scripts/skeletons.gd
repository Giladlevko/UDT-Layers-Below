extends Node2D
class_name Skeletons
@onready var confetti_particles: ConfettiParticles = $confetti_particles
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_found():
	confetti_particles.emit()
	colli.set_deferred("disabled",true)
	await get_tree().create_timer(1).timeout
	SignalBus.puzzle_solved.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		on_found()
	pass # Replace with function body.
