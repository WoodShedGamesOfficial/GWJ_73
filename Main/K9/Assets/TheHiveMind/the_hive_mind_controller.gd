extends Node
class_name K9s_Hive_Mind_Manager
##@experimental

##README   v ಠ益ಠ v 

##yet another version of my cool lil AI managment baby

##im still practicing better docs so bear with me


@export var enemy_troop_array = [preload("res://Main/K9/Assets/TROOPS/Basic_ENEMYTROOP.tscn") ]

var enemy_spawn_point_array = []

@export var isAwake : bool = true
var spawn_time : float = randf_range(3.5, 7.5)

const LEVEL_0 = preload("res://Main/K9/Lvls/Lvl_0/level_0.tscn")
const MAIN_MENU = preload("res://Main/K9/Lvls/main_menu.tscn")
const LOAD_SCREEN = preload("res://Main/K9/Lvls/load_screen.tscn")
const K_9_DEV_ROOM = preload("res://Main/K9/Lvls/Dev_room/k_9_dev_room.tscn")



# --function blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for spawnpoint in $EnemySpawnPoints.get_children():
		enemy_spawn_point_array.append(spawnpoint.transform.origin)
	
	#print("enemy spawn point locations:  " + str(enemy_spawn_point_array))
	
	#player_tower_heart_pos = $TowerHearts/PlayerHeart.global_transform.origin
	#enemy_tower_heart = $TowerHearts/EnemyHeart.global_transform.origin
	
	$Timers/SpawnTimer.connect('timeout', spawn_enemy)
	$Timers/ResourceTimer.connect('timeout', add_enemy_resources)
	
	if isAwake:
		$Timers/WaveStart.start()
	
	$SpawnButtons/FriendlyTroopSpawnButton/InteractionRadius.monitoring = false
	await  $Timers/WaveStart.timeout
	$SpawnButtons/FriendlyTroopSpawnButton/InteractionRadius.monitoring = true
	
	if isAwake:
		$Timers/SpawnTimer.wait_time = spawn_time
		$Timers/SpawnTimer.start()
	
	
	
	pass # Replace with function body.
	

func _process(delta):
	if $Timers/WaveStart.is_stopped() != true:
		$SpawnButtons/FriendlyTroopSpawnButton/Label.text = ("Time till start:  " + str($Timers/WaveStart.time_left))
		#print(str($Timers/WaveStart.time_left))
	else:
		$SpawnButtons/FriendlyTroopSpawnButton/Label.text = str('price of  troop : 50')
	pass

func spawn_enemy():
	
	var enemy_p = enemy_troop_array.pick_random()
	var enemy_i = enemy_p.instantiate()
	
	$EnemyNPCs.add_child(enemy_i)
	enemy_i.faction = 1
	enemy_i.transform.origin = enemy_spawn_point_array.pick_random()
	$Timers/SpawnTimer.wait_time = randf_range(3.5, 7.5)
	#print("enemy spawned" + str($Timers/SpawnTimer.wait_time))
	
	pass
	

const ENEMY_TROOP_P = preload("res://Main/K9/Assets/TROOPS/Basic_ENEMYTROOP.tscn")

func add_enemy_resources():
	
	
	GlobalHiveMind.enemies_gold_coins += 100
	
	print('the hivemind gets stronger')
	
	while GlobalHiveMind.enemies_gold_coins >= 250:
		var enemy_i = ENEMY_TROOP_P.instantiate()
		GlobalHiveMind.enemies_gold_coins -= 50
		await get_tree().create_timer(0.5).timeout
		$EnemyNPCs.add_child(enemy_i)
		enemy_i.faction = 1
		enemy_i.transform.origin = enemy_spawn_point_array.pick_random()
		print(enemy_i.name)
			
	
	pass
	


func _on_players_heart_towers_death():
	printt("heart destroyed, hivemind changing levels" )
	
	
	
	
	pass # Replace with function body.
