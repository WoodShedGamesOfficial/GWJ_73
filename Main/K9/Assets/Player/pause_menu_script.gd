extends Control

@onready var mm_path = load("res://Main/K9/Lvls/main_menu.tscn")

func _ready():
	visible = false
	
	$VBoxContainer/Button.connect('pressed', resume)
	$VBoxContainer/Button2.connect('pressed', return_to_MM)
	$VBoxContainer/Button3.connect('pressed', eject_game)
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().paused =! get_tree().paused
		visible =! visible
	pass

func resume():
	visible = false
	get_tree().paused =! get_tree().paused
	pass

func return_to_MM():
	#get_tree().paused = false
	get_tree().change_scene_to_packed(mm_path)
	
	pass
	

func eject_game():
	get_tree().quit()
	pass
