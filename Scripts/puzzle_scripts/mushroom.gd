extends Node2D
class_name Mushroom

@export_range(-1,1,2) var dir_x:int = -1
var base_pos:Vector2
@onready var confetti_particles: ConfettiParticles = $confetti_particles
@onready var interact_coli: CollisionShape2D = $interact_zone/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = global_position
	sprite.rotation_degrees = -90 * dir_x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var can_push:bool = true
func push():
	if(!can_push):return
	interact_coli.set_deferred("disabled",true)
	can_push = false
	print("push!")
	var tween:=create_tween()
	var new_pos:Vector2 = base_pos + Vector2(5*dir_x,0)
	confetti_particles.rotation_degrees = -90*dir_x
	tween.tween_property(self,"global_position",new_pos,1.5)
	await tween.finished
	confetti_particles.emit()
	await get_tree().create_timer(1).timeout
	SignalBus.puzzle_solved.emit()
	pass


func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		SignalBus.display_message.emit("Press me...")
	pass # Replace with function body.
