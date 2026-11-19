extends Control
class_name InventorySlot

@onready var texture_rect: TextureRect = $Panel/MarginContainer/TextureRect


@export var slot_data:InvSlotData:
	set(val):
		slot_data = val
		update_data()
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func clear():
	slot_data.clear()
	update_data()

func update_data():
	if(is_node_ready() and slot_data):
		texture_rect.texture = slot_data.texture

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if(
		data is InventorySlot
		and data.slot_data
		and data.slot_data.slot_type == slot_data.slot_type
		):
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp:=slot_data
	slot_data = data.slot_data
	data.slot_data = temp
	pass

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(make_drag_preview())
	return self

func make_drag_preview()->Control:
	var preview: = TextureRect.new()
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture = slot_data.texture
	preview.custom_minimum_size = Vector2(32,32)
	return preview
