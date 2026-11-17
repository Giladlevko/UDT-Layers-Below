extends Node


signal start_cooldown(dur:float)
signal cooldown_ended
signal emit_tile_particle(part_count:int,color:Color)
signal particle_finished()
signal display_message(message:String)
signal on_take_item(data:InvSlotData)
signal on_item_taken(successful:bool)
signal currency_changed()
