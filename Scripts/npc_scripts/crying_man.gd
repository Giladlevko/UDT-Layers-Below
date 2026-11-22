extends CharacterBody2D
class_name CryingMan

enum states{crying,speaking}
var state:states = states.crying
var skeletons_found:bool = false
@export_range(-1,1,2) var dir_x:int
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.puzzle_solved.connect(on_puzzle_solved)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	if(!is_on_floor()):velocity.y += 300*delta
	if(state == states.speaking):
		var dir:Vector2 = global_position.direction_to(Global.player.global_position)
		anim.flip_h = dir.x<0
	elif(state == states.crying):
		anim.flip_h = (dir_x < 0)
	pass


func on_puzzle_solved():
	skeletons_found = true
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		if(skeletons_found):
			pass
		else:
			pass
	pass # Replace with function body.
