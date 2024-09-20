extends Control
class_name SAGD_Loading_screen

var fakeLoadReady : bool = false


func _ready():
	if GlobalLibrary.level_path == null:
		GlobalLibrary.level_path = preload("res://Main/K9/Lvls/main_menu.tscn")
	#
	$Label2.text = GlobalLibrary.fun_facts_array.pick_random()
	#$Label2.text = # GlobalLibrary.fun_fact_array.pick_random()
	
	#resets globalLib scores
	GlobalLibrary.friendly_losses = 0
	GlobalLibrary.enemy_losses = 0
	GlobalLibrary.total_gold_spent = 0
	pass

func _input(event):
	if Input.is_anything_pressed() and fakeLoadReady == true:
		get_tree().change_scene_to_packed(GlobalLibrary.level_path)
	pass
	


func _on_timer_timeout():
	#get_tree().change_scene_to_packed(GlobalLibrary.level_path)
	
	pass


func _on_timer_2_timeout():
	$AnimatedSprite2D.visible = false
	
	$Label3.visible = true
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(GlobalLibrary.level_path)
