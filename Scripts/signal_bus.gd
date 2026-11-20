extends Node


signal start_cooldown(dur:float)
signal cooldown_ended
signal emit_tile_particle(part_count:int,color:Color)
signal particle_finished()
signal display_message(message:String)

signal on_take_item(data:InvSlotData)

signal on_item_taken(successful:bool,data:InvSlotData)

signal currency_changed()

signal detector_range_changed
signal vision_range_changed

signal dialog_started(dialog_name:String)
signal dialog_ended(dialog_name:String)
