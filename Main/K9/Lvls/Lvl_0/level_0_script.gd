extends Node2D
class_name K9s_level_manager

@export var hiveminds_base_gold : int = 550

const FINAL_LEVEL = preload("res://Main/K9/Lvls/FinalLevel/final_level.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	#GlobalHiveMind.friendly_tower_heart_pos_array.clear()
	#GlobalHiveMind.enemy_heart_pos_array.clear()
	
	GlobalHiveMind.enemies_gold_coins = hiveminds_base_gold
	
	GlobalHiveMind.friendly_troop_count.clear()
	GlobalHiveMind.enemy_troop_count.clear()
	
	pass # Replace with function body.
 


func _on_bk_music_finished():
	$BKMusic.pitch_scale = randf_range(0.8, 1.1)
	$BKMusic.play()
	pass # Replace with function body.


func _on_enemy_heart_towers_death():
	print('level zero root received signal')
	GlobalHiveMind.friendly_tower_heart_pos_array.clear()
	GlobalHiveMind.enemy_heart_pos_array.clear()
	get_tree().change_scene_to_packed(FINAL_LEVEL)
	
	pass # Replace with function body.
