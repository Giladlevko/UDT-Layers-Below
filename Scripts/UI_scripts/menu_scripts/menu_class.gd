extends UI
class_name MenuUI

##Lightens the screen, sets the dark screen and the button SFX to their UI_Global counterparts
func setup_UI():
	self.dark_screen = UI_GLOBAL.dark_screen
	self.set_button_sfx_to_global()
	self.song = UI_GLOBAL.song_player
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#after self vars are ready enter trans
	self.enter_trans()
	
