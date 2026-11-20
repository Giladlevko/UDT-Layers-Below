extends CharacterBody2D
class_name GUARD
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var dialog:DialogData

enum states{LevelEND,LevelSTART}
var state:states = states.LevelEND
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
		if(state == states.LevelEND):
			if(!Global.quota_reached):
				var versions_count = 3
				var r = randi_range(1,versions_count)
				UI_GLOBAL.text_box.play_dialog("give_me_coal"+str(r))
			else:
				var versions_count = 3
				var r = randi_range(1,versions_count)
				UI_GLOBAL.text_box.play_dialog("you_can_pass"+str(r))
		elif(state == states.LevelSTART):
			pass
		pass
