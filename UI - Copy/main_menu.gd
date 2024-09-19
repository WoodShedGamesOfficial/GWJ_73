extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	General.scene_before = "menu"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_credits_pressed():
	pass # write in here your credits scene get_tree().change_scene_to("res://credits").


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")
