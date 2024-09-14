extends Control
class_name K9_Main_menu

@export var dev_room_path : PackedScene
@export var level_0_path : PackedScene



func _ready():
	connect_buttons()
	
	settup_menu() #hides credits and options panel
	pass
	

func connect_buttons():
	
	$DevRoomButton.connect('pressed', go_to_devRoom)
	$ButtonContainer/Eject.connect('pressed', eject_game)
	$ButtonContainer/Credits.connect('pressed', toggle_credits_panel)
	$ButtonContainer/Options.connect('pressed', toggle_options_panel)
	$ButtonContainer/Start.connect('pressed', start_level_0)
	
	pass
	

func settup_menu():
	$Options_panel.visible = false
	$CreditsPanel.visible = false
	
	pass
	

func go_to_devRoom():
	
	if dev_room_path != null:
		get_tree().change_scene_to_packed(dev_room_path)
	else:
		print("no dev_room path assigned")
	
	
	pass
	

func eject_game():
	
	get_tree().quit()
	
	pass
	

func toggle_options_panel():
	var options_panel = $Options_panel
	
	options_panel.visible =! options_panel.visible #flips a bit
	
	#!options_panel.visible
	
	#if options_panel.visible == false:
		#options_panel.visible = true
	#else:
		#options_panel.visible = false
		#
	
	pass
	

func toggle_credits_panel():
	var lots_of_CP = $CreditsPanel
	
	lots_of_CP.visible =! lots_of_CP.visible
	
	pass
	

func start_level_0():
	
	if level_0_path != null:
		get_tree().change_scene_to_packed(level_0_path)
	else:
		print("no level 0 assigned")
	
	pass
	
