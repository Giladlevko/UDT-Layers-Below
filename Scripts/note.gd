extends Node2D
class_name Note
@export_range(1,4,1) var note_id:int = 1
@onready var interact_area: InteractArea = $InteractArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact_area.interact_popup.interacted.connect(on_interact)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("DASH")):
		note_id +=1
	pass



func on_interact():
	UI_GLOBAL.text_box.dialog_data = Global.npc_dialog_data
	UI_GLOBAL.text_box.play_dialog("note"+str(note_id))
	pass
