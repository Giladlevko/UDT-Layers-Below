extends StaticBody2D
class_name ExitDoor
signal door_opened
@onready var flash_light: PointLight2D = $FlashLight
var base_pos:Vector2
@onready var anim: AnimatedSprite2D = $anim

@onready var guard_pos_node: Node2D = $guard_pos_node
@export var guard_pos:Vector2

var opened:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = global_position
	Global.exit_door = self
	SignalBus.open_exit.connect(open)
	SignalBus.puzzle_solved.connect(on_puzzle_sloved)
	guard_pos_node.global_position = guard_pos
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open():
	opened = true
	var tween := create_tween()
	print("moving...")
	var new_pos = base_pos + Vector2(0,-32)
	tween.tween_property(self,"position",new_pos,1.5)
	await tween.finished
	anim.play("open")
	door_opened.emit()




func on_puzzle_sloved():
	flash_light.visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PLAYER and !opened:
		SignalBus.display_message.emit("Door is locked! Continue to explore!") 
		SignalBus.display_message.emit("Find something that would open the door!")
	pass # Replace with function body.
