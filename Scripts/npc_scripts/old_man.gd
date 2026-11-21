extends CharacterBody2D

@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_particle: CPUParticles2D = $CPUParticles2D

var dialog_to_play:String = "water_canteen"
@export var item:InvSlotData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.dialog_ended.connect(on_dialog_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
	if(!is_on_floor()):velocity.y += 300
	var dir = global_position.direction_to(Global.player.global_position)
	anim.flip_h = dir.x<0
	smoke_particle.tangential_accel_max = sign(dir.x)
	smoke_particle.tangential_accel_min = sign(dir.x)
	
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		UI_GLOBAL.text_box.dialog_data = Global.npc_dialog_data
		UI_GLOBAL.text_box.play_dialog(dialog_to_play)
	pass # Replace with function body.


func on_dialog_end(dialog_name:String):
	if(dialog_name == dialog_to_play):
		SignalBus.on_take_item.emit(item)
		colli.set_deferred("disabled",true)
	pass
