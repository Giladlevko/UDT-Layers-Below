extends Node2D
class_name ExitDoor
signal door_opened
@onready var flash_light: PointLight2D = $FlashLight
var base_pos:Vector2
@onready var sprite: Sprite2D = $Sprite2D
@onready var guard_pos_node: Node2D = $guard_pos_node
@export var guard_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = global_position
	Global.exit_door = self
	SignalBus.open_exit.connect(open)
	SignalBus.puzzle_solved.connect(on_puzzle_sloved)
	flash_light.visible = false
	guard_pos_node.global_position = guard_pos
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open():
	
	var tween := create_tween()
	print("moving...")
	tween.tween_property(sprite,"position",Vector2(0,-32),1.5)
	await tween.finished
	door_opened.emit()

func close():
	var tween := create_tween()
	tween.tween_property(sprite,"position",Vector2(0,0),1.5)


func on_puzzle_sloved():
	flash_light.visible = true
