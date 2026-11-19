extends CharacterBody2D
class_name GUARD
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var dialog:DialogData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	if(!is_on_floor()):velocity.y += 300
	var dir:Vector2 = global_position.direction_to(Global.player.global_position)
	anim.flip_h = dir.x<0
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		UI_GLOBAL.text_box.dialog_data = dialog
		var r = randi_range(1,3)
		UI_GLOBAL.text_box.play_dialog("give_me_coal"+str(r))
		#dialog logic here
		pass
