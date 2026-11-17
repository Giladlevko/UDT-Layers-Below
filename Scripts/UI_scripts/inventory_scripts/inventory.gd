extends UI
class_name INVENTORY
@onready var close_button: Button = $MarginContainer/VBoxContainer/close_button
@onready var tools_container: GridContainer = $MarginContainer/VBoxContainer/inventory_panel/MarginContainer/VBoxContainer/toolsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_button_sfx_to_global()
	self.buttons = [close_button]
	self.connect_buttons()
	SignalBus.on_take_item.connect(take_item)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	tween_visibility(self,false)
	pass # Replace with function body.

func take_item(data:InvSlotData):
	if(data.slot_type == "Tool"):
		SignalBus.on_item_taken.emit(add_tool(data))
	else:
		SignalBus.on_item_taken.emit(add_item(data))

func add_tool(data:InvSlotData)->bool:
	for slot:InventorySlot in tools_container.get_children():
		if(!slot.slot_data or !slot.slot_data.texture):
			slot.slot_data = data
			return true
	return false

func add_item(data:InvSlotData)->bool:
	for slot:InventorySlot in tools_container.get_children():
		if(!slot.slot_data or !slot.slot_data.texture):
			slot.slot_data = data
			return true
	return false
