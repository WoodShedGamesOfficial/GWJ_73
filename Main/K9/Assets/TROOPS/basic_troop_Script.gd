extends CharacterBody2D
class_name K9s_Troop_creator
##@experimental
##trying to simplify and replace Friendly/hostile troop code to unscrew the AI behavior


@export_enum("friendly", "hostile") var faction = 'friendly'

@export var TROOP_STATS = {
	'health' : 25,
	'walk_speed' : 0,
	'base_damage' : 5,
}

@export_enum('blunt', "fire", 'poison', 'ice', 'sharp') var damage_type = 'sharp'


#===========

@onready var nav_agent = $NavAgent
@onready var attack_radius = $AttackRadius

#========

var movement_target : Vector2

#==============

const BLOODSPLAT_p = preload("res://Main/K9/Assets/Fx/bloodsplat.tscn")

#==========

func _ready():
	assign_faction()
	
	init_navigation()
	
	TROOP_STATS.walk_speed = randf_range(100.0, 450.0)
	
	
	pass
	

func assign_faction():
	
	match faction:
		"friendly" : 
			add_to_group('Player')
			add_to_group('friendly') # Grouping for behavioral reasons
			add_to_group('teleportable') # Grouping for behavioral reasons
			
			$Sprites/Head.modulate = GlobalLibrary.player_color #Color Coding
			$Sprites/Feet.modulate = GlobalLibrary.player_color  #Color Coding
			
			set_collision_layer_value(5, true) # assigned to friendly troop layer
			
			set_collision_mask_value(2, true)#detects enemy groups
			
			#navigation rules
			nav_agent.set_navigation_layer_value(1, true)
			if GlobalHiveMind.enemy_heart_pos_array.is_empty() != true:
				nav_agent.target_position = GlobalHiveMind.enemy_heart_pos_array.front()
			
			$HitBox.set_collision_mask_value(2, true)
			
			name = GlobalLibrary.firendly_name_array.pick_random()
			GlobalHiveMind.friendly_troop_count.append(name)
			
			$AttackRadius.set_collision_mask_value(5, true)
			
		'hostile' : 
			add_to_group("enemy") # Grouping for behavioral reasons
			add_to_group('teleportable') # Grouping for behavioral reasons
			
			$Sprites/Head.modulate = Color.DARK_RED #Color Coding
			$Sprites/Feet.modulate = Color.DARK_RED #Color Coding
			
			set_collision_layer_value(2, true) #is assigned to the enemy layer
			
			set_collision_mask_value(5, true) #detects players/ friendly troops
			set_collision_mask_value(1, true) #detect player
			
			nav_agent.set_navigation_layer_value(2, true)
			if GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
				nav_agent.target_position = GlobalHiveMind.friendly_tower_heart_pos_array.front()
			
			$AttackRadius.set_collision_mask_value(2, true)
			$AttackRadius.set_collision_mask_value(1, true)
			
			$HitBox.set_collision_mask_value(1, true)
			$HitBox.set_collision_mask_value(5, true)

			name = GlobalLibrary.hostile_names_array.pick_random()
			
			GlobalHiveMind.enemy_troop_count.append(name)
	
	$NameLabel/Name.text = str(name)
	pass
	

func init_navigation():
	var agent: RID = get_rid()
	
	nav_agent.velocity_computed.connect(Callable(_on_nav_agent_velocity_computed))
	
	# Enable avoidance
	NavigationServer2D.agent_set_avoidance_enabled(agent, true)
	#nav_agent.connect(Callable(_on_nav_agent_velocity_computed))
	# Create avoidance callback
	NavigationServer2D.agent_set_avoidance_callback(agent, Callable(self, "_avoidance_done"))

	## Disable avoidance
	#NavigationServer2D.agent_set_avoidance_enabled(agent, false)
	## Delete avoidance callback
	#NavigationServer2D.agent_set_avoidance_callback(agent, Callable())
	
	pass
	

func set_movement_target(movement_target: Vector2):
	nav_agent.set_target_position(movement_target)
	
	pass
	

func _physics_process(delta):
	nav_manager(delta)
	pass
	


func _process(delta):
	$Sprites.look_at(nav_agent.get_next_path_position())
	
	var hasDied : bool = false
	if TROOP_STATS.health <= 0 and not hasDied:
		death()
		hasDied = true
	pass


func _on_nav_agent_velocity_computed(safe_velocity):
	
	velocity = safe_velocity
	move_and_slide()
	
	pass # Replace with function body.



func nav_manager(delta):
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(nav_agent.get_next_path_position()) * TROOP_STATS.walk_speed
	
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	if nav_agent.is_navigation_finished():
		return
	
	
	
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_nav_agent_velocity_computed(new_velocity)
	
	
	
	pass
	

func hurt(damage, damage_type) -> int:
	var BLOODSPLAT_i = BLOODSPLAT_p.instantiate()
	
	if TROOP_STATS.health >= 1:
		#$Audio/HurtSFX.pitch_scale(0.85, 1.5)
		get_tree().current_scene.add_child(BLOODSPLAT_i)
		BLOODSPLAT_i.transform.origin = transform.origin
		
		$Audio/HurtSFX.play(0.0)
		TROOP_STATS.health -= damage
	else:
		death()
	
	if is_in_group('enemy'):
		GlobalHiveMind.players_gold_coins += 10
	elif is_in_group('enemy'):
		GlobalHiveMind.enemies_gold_coins += 5
	print(str(TROOP_STATS.health))
	return TROOP_STATS.health
	

func death():
	var scream_chance = randf_range(-100, 100)
	var BLOODSPLAT_i = BLOODSPLAT_p.instantiate()
	var death_howl = $Audio/DeathSFX
	
	if scream_chance >= 95:
		death_howl.pitch_scale = 1
		death_howl.stream = preload("res://Main/K9/Assets/Audio/SFX/Whilhelm_Scream.wav")
	
	get_tree().current_scene.add_child(BLOODSPLAT_i)
	BLOODSPLAT_i.transform.origin = transform.origin
	BLOODSPLAT_i.scale = BLOODSPLAT_i.scale * 1.75
	
	if is_in_group('friendly'):
		GlobalHiveMind.friendly_troop_count.erase(name)
		$Audio/DeathSFX.pitch_scale = randf_range(.80, 2.0)
		$Audio/DeathSFX.play(0.0)
		#await $Audio/DeathSFX.finished
		GlobalHiveMind.enemies_gold_coins += 25
		print(name + "  died")
		queue_free()
	elif is_in_group('enemy'): 
		GlobalHiveMind.enemy_troop_count.erase(name)
		$Audio/DeathSFX.pitch_scale = randf_range(0.80, 1.6)
		$Audio/DeathSFX.play(0.0)
		GlobalHiveMind.players_gold_coins += 50
		#await $Audio/DeathSFX.finished
		print(name + "  died")
		queue_free()
	
	#queue_free()
	pass
	

func attack():
	var damage = randi_range(TROOP_STATS.base_damage, TROOP_STATS.base_damage * 3)
	
	for body in $HitBox.get_overlapping_bodies():
		if body.has_method('hurt'):
			body.hurt(damage, damage_type)
			$Audio/SwordClash.play(0.0)
			print(name + str(faction) + "   hurt:   " + str(body.name))
	pass


func _on_nav_timer_timeout():
	var new_velocity: Vector2 = global_position.direction_to(nav_agent.get_next_path_position()) * TROOP_STATS.walk_speed
	
	
	
	match faction:
		'friendly' :
			for body in $AttackRadius.get_overlapping_bodies():
				if body != null and body.is_in_group('enemy'):
					nav_agent.target_position = body.global_transform.origin
					#$AttackTimer.start()
				elif GlobalHiveMind.enemy_heart_pos_array.is_empty() != true:
					nav_agent.target_position = GlobalHiveMind.enemy_heart_pos_array.front()
		'hostile' :
			for body in $AttackRadius.get_overlapping_bodies():
				if body != null and body.is_in_group('Player') or body.is_in_group('friendly'):
					nav_agent.target_position = body.global_transform.origin
					#$AttackTimer.start()
				elif GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
					nav_agent.target_position = GlobalHiveMind.friendly_tower_heart_pos_array.front()
	pass # Replace with function body.


func _on_attack_radius_body_entered(body):
	if $AttackTimer.is_stopped():
		$AttackTimer.start()
	
	match faction:
		'friendly' :
				if body != null and body.is_in_group('enemy'):
					nav_agent.target_position = body.transform.origin
				elif GlobalHiveMind.enemy_heart_pos_array.is_empty() != true:
					nav_agent.target_position = GlobalHiveMind.enemy_heart_pos_array.front()
		'hostile' :
				if body != null and body.is_in_group('Player') or body.is_in_group('friendly'):
					nav_agent.target_position = body.transform.origin
				elif GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
					nav_agent.target_position = GlobalHiveMind.friendly_tower_heart_pos_array.front()
	pass # Replace with function body.
