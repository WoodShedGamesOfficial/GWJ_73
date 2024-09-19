extends Control
class_name SAGD_Loading_screen

func _ready():
	#$Label2.text = # GlobalLibrary.fun_fact_array.pick_random()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_packed(GlobalSaaeb.where_to_go)


func _on_timer_2_timeout():
	$AnimatedSprite2D.visible = false
	
	$Label3.visible = true
