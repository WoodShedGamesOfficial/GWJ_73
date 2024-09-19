extends Control
class_name K9_Main_menu

@export var dev_room_path : PackedScene
@export var level_0_path : PackedScene



func _ready():
	
	
	connect_buttons()
	
	settup_menu() #hides credits and options panel
	
	get_tree().paused = false
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
	pass
	

func toggle_tut():
	var tut_panel = $Tutorial_confirm
	
	tut_panel.visible =! tut_panel.visible
	
	pass
	

func goto_tutorial_island():
	const island_path = preload("res://Main/SAGD/Lvls_Menus/tutorial_island (2).tscn")
	get_tree().change_scene_to_packed(island_path)
	pass
	

func goto_level_0():
	const lvl0_p = preload("res://Main/K9/Lvls/Lvl_0/level_0.tscn")
	
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
	
