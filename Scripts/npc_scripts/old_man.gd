extends CharacterBody2D
@export var dialog_data:DialogData
@onready var colli: CollisionShape2D = $Area2D/CollisionShape2D
var dialog_to_play:String = "water_canteen"
@export var item:InvSlotData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.dialog_ended.connect(on_dialog_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER:
		UI_GLOBAL.text_box.dialog_data = dialog_data
		UI_GLOBAL.text_box.play_dialog(dialog_to_play)
	pass # Replace with function body.


func on_dialog_end(dialog_name:String):
	if(dialog_name == dialog_to_play):
		SignalBus.on_take_item.emit(item)
		colli.set_deferred("disabled",true)
	pass
