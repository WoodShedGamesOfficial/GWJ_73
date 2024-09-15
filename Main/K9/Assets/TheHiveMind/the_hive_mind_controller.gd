extends Node


@export var enemy_troop_array = [preload('res://Main/K9/Assets/Enemies/basic_enemy_000.tscn') ]

var enemy_spawn_point_array = []



# --function blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for spawnpoint in $EnemySpawnPoints.get_children():
		enemy_spawn_point_array.append(spawnpoint.transform.origin)
	
	print("enemy spawn point locations:  " + str(enemy_spawn_point_array))
	
	#player_tower_heart_pos = $TowerHearts/PlayerHeart.global_transform.origin
	#enemy_tower_heart = $TowerHearts/EnemyHeart.global_transform.origin
	
	$Timers/SpawnTimer.connect('timeout', spawn_enemy)
	$Timers/SpawnTimer.start()
	
	
	
	
	pass # Replace with function body.
	

func spawn_enemy():
	
	var enemy_p = enemy_troop_array.pick_random()
	var enemy_i = enemy_p.instantiate()
	$EnemyNPCs.add_child(enemy_i)
	enemy_i.transform.origin = enemy_spawn_point_array.pick_random()
	print("enemy spawned" + str(enemy_i.transform.origin))
	
	pass
	
