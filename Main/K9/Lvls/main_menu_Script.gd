extends Node2D
class_name K9_Main_menu

@export var dev_room_path : PackedScene
@export var level_0_path : PackedScene

#var fun_facts_array = [ #LEGACY
	#"The tallest tower in the world is the Burj Khalifa, standing at 2,717 feet tall!",
	#"one of the oldest towers in the world was built around 10650 - 9650 BCE!",
	#"Ophiocordyceps unilateralis is a type of predatory fungus that hijacks its hosts bodily functions",
	#'You would have to build a tower 452.03 million miles high to reach the closest point in Jupiters Orbit.',
	#"One 'Astronomical Unit' is roughly equivalent to: 92955807.267 imperial miles",
	#"It's roughly 1,000 AU to the inner region of our solar system",
	#"The deepest hole on earth is the Kora Superdeep Borehole, spanning 40,230ft deep with a rough 9 inch diameter",
	#"Sơn Đoòng cave passage is the largest known cave passage in the world by volume... you could fit so much spaghetti in that",
	#
#]

func _ready():
	get_tree().paused = false #for debug redundancy
	
	connect_buttons()
	
	settup_menu() #hides credits and options panel
	
	splash_time_baby()
	
	
	pass
	

func splash_time_baby():
	if GlobalLibrary.hasSplashed == false:
		$SplashScreen/SplashAnim.play("Spash")
		GlobalLibrary.hasSplashed = true
		await $SplashScreen/SplashAnim.animation_finished
		GlobalLibrary.hasSplashed = true
		$SplashScreen.queue_free()
	else:
		$SplashScreen.queue_free()
	pass


func connect_buttons():
	
	$DevRoomButton.connect('pressed', go_to_devRoom)
	$ButtonContainer/Eject.connect('pressed', eject_game)
	$ButtonContainer/Credits.connect('pressed', toggle_credits_panel)
	$ButtonContainer/Options.connect('pressed', toggle_options_panel)
	$ButtonContainer/Start.connect('pressed', toggle_tut)
	
	#start game
	$Tutorial_confirm/Yes.connect('pressed', goto_tutorial_island)
	$Tutorial_confirm/No.connect('pressed', goto_level_0)
	pass
	

func _input(event):
	if Input.is_anything_pressed() and get_tree().current_scene.get_node_or_null('SplashScreen') and $SplashScreen/SplashAnim.is_playing():
		$SplashScreen.queue_free()
		
	else:
		return 
	pass
	

func settup_menu():
	$Options_panel.visible = false
	$CreditsPanel.visible = false
	$Tutorial_confirm.visible = false
	
	$FunFacts.text = GlobalLibrary.fun_facts_array.pick_random()
	
	pass
	

func toggle_tut():
	var tut_panel = $Tutorial_confirm
	
	tut_panel.visible =! tut_panel.visible
	
	pass
	

func goto_tutorial_island():
	var island_path = load("res://Main/SAGD/Lvls_Menus/tutorial_island (2).tscn")
	get_tree().change_scene_to_packed(island_path)
	pass
	

func goto_level_0():
	var lvl0_p = load("res://Main/K9/Lvls/Lvl_0/level_0.tscn")
	
	get_tree().change_scene_to_packed(lvl0_p)
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
	
