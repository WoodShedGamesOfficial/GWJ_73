extends Node2D


@export var hiveminds_base_gold : int = 550
var canLeave : bool 
const MAIN_MENU = preload("res://Main/SAGD/Assets/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalHiveMind.enemies_gold_coins = hiveminds_base_gold
	
	$CanvasLayer/EndGame.visible = false
	
	GlobalHiveMind.friendly_troop_count.clear()
	GlobalHiveMind.enemy_troop_count.clear()
	#$World/WorldNav.bake_navigation_polygon()
	
	#$TheHiveMind/TowerHearts/PlayersHeart.set_final_level()
	#$TheHiveMind/TowerHearts/EnemyHeart2.set_final_level()

func _input(event):
	
	if Input.is_anything_pressed() and canLeave: 
		get_tree().change_scene_to_packed(MAIN_MENU)
	
	pass

func _on_enemy_heart_towers_death():
	
	$CanvasLayer/EndGame.visible = true
	
	await get_tree().create_timer(5.0).timeout
	
	$CanvasLayer/EndGame/ContinueLabel.visible = true
	canLeave = true
	
	
	pass # Replace with function body.


func _on_bk_music_finished():
	#var backwards : bool #tried playing it backwards ping pong style 
	
	$BKMusic.pitch_scale = randf_range(0.8, 1.1)
	$BKMusic.play()
	
	
	pass # Replace with function body.
