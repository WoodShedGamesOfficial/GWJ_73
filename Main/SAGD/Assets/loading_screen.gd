extends Control
class_name SAGD_Loading_screen

var fakeLoadReady : bool

func _ready():
	
	$Label2.text = GlobalLibrary.fun_facts_array.pick_random()
	#$Label2.text = # GlobalLibrary.fun_fact_array.pick_random()
	pass

func _input(event):
	if Input.is_anything_pressed() and fakeLoadReady:
		get_tree().change_scene_to_packed(GlobalLibrary.level_path)
	pass
	


func _on_timer_timeout():
	#get_tree().change_scene_to_packed(GlobalLibrary.level_path)
	
	pass


func _on_timer_2_timeout():
	$AnimatedSprite2D.visible = false
	
	$Label3.visible = true
	
	fakeLoadReady = true
