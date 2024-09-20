extends Node2D
class_name K9s_level_manager

@export var hiveminds_base_gold : int = 550

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalHiveMind.enemies_gold_coins = hiveminds_base_gold
	pass # Replace with function body.
 


func _on_bk_music_finished():
	$BKMusic.pitch_scale = randf_range(0.8, 1.1)
	$BKMusic.play()
	pass # Replace with function body.
