extends CharacterBody2D
class_name ORE

var color:Color:
	set(val):
		color = val
		modulate = color

enum types{Gem,Coal}
var type:types = types.Gem

var grav = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_velocity()
	pass # Replace with function body.

func init_velocity():
	velocity.x = randi_range(10,100) * [-1,1].pick_random()
	velocity.y = randi_range(-250,-10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision_info: = move_and_collide(velocity * delta)
	if(collision_info):
		velocity = velocity.bounce(collision_info.get_normal())
	velocity = velocity - velocity * delta * 2
	if(!is_on_floor()):
		velocity.y += grav * delta
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is PLAYER):
		if(type == types.Gem):
			Global.change_currency_amount("Gems",1)
		else:
			Global.change_currency_amount("Coal",1)
		queue_free()
	pass # Replace with function body.
