extends Area2D
class_name InteractArea
@onready var interact_popup: InteractPopup = $InteractPopup
var can_interact:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is PLAYER and can_interact:
		interact_popup.popup()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is PLAYER and can_interact:
		interact_popup.pop_off()
	pass # Replace with function body.
