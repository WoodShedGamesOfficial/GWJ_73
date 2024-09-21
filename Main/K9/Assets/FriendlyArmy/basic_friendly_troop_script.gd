extends CharacterBody2D


var names = [
"Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Helen", "Ivan", "Jack",
 "Kate", "Leo", "Mia", "Noah", "Olivia", "Paul", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", 
"Vincent", "William", "Xander", "Yvette", "Zachary", "Abigail", "Benjamin", "Chloe", "Daniel", "Emily", 
"Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine", "Liam", "Maya", "Nathan", "Olivia", "Parker",
 "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent", "William", "Xander", "Yvette", "Zachary", "Abigail",
 "Benjamin", "Chloe", "Daniel", "Emily", "Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine", "Liam", "Maya",
 "Nathan", "Olivia", "Parker", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent", "William", "Xander", "Yvette",
 "Zachary", "Abigail", "Benjamin", "Chloe", "Daniel", "Emily", "Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine",
 "Liam", "Maya", "Nathan", "Olivia", "Parker", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent",
 "William", "Xander", "Yvette", "Zachary", "SAGD", "DevinGD", "TQ", "Dutt"
]



@onready var navigation_agent = $NavigationAgent2D
@onready var friendly_anim = $FriendlyAnim


@export var TROOPSTATS = {
	'health' : 25,
	'walk_speed' : 50.0,
	'damage' : 5,
	
}

var target_pos : Vector2

@export_enum('blunt', 'sharp', 'fire', 'poison', 'ice') var damage_type = 'blunt'

var movement_speed: float = 200.0
var movement_target_position : Vector2

@onready var sprites = $Sprites
@onready var attack_timer = $AttackTimer

var canAttack : bool 

#@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	name = names.pick_random()
	$Control/Label.text = name
	GlobalHiveMind.friendly_troop_count.append(name)
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	if GlobalHiveMind.enemy_heart_pos_array.is_empty() != true:
		movement_target_position = GlobalHiveMind.enemy_heart_pos_array.front()
		set_movement_target(movement_target_position)
	
	add_to_group("Player")
	add_to_group("Troop")
	$GoopVfx.restart()
	
	
	pass
	


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)
	pass
	

func set_movement_target(movement_target: Vector2):
	
	navigation_agent.target_position = movement_target
	
	#sprites.look_at(movement_target)
	pass
	

func _physics_process(delta):
	
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = (current_agent_position.direction_to(next_path_position) * TROOPSTATS.walk_speed)
	move_and_slide()
	
	#look_at(navigation_agent.get_next_path_position())
	
	for body in $AttackRadius.get_overlapping_bodies():
		if body != null:
			if body.is_in_group("Enemy") and $AttackTimer.is_stopped():
				$AttackTimer.start(0.0)
				#look_at(body.transform.origin)
				await $AttackTimer.timeout
				attack(body)
		
	pass
	

func _process(delta):
	$Control/Label.rotation = 0
	
	for body in $VisiblilityRadius.get_overlapping_bodies():
		if body != null and body.is_in_group("Enemy"):
			look_at(body.transform.origin)
			if body.transform.origin.distance_to(transform.origin) < transform.origin.distance_to(body.transform.origin):
				movement_target_position = body.transform.origin
				look_at(body.transform.origin)
				set_movement_target(movement_target_position)
		else:
			look_at(navigation_agent.get_next_path_position())
			movement_target_position = GlobalHiveMind.enemy_heart_pos_array.front()
			set_movement_target(movement_target_position)
	
	pass
	

func prepare_attack(body):
	
	if body.is_in_group("Enemy"):
		canAttack = true
		#$AttackTimer.start()
		
		#attack(body)

	pass
	

func attack(body):
	var damage = randi_range(TROOPSTATS.damage, (TROOPSTATS.damage * 2))
	var attack_sfx = $SFX/AttackSFX

	#print("troop attacked" + body.name)
	
	if canAttack and body != null:    #body.has_method("hurt") and 
		body.hurt(damage, damage_type)
		
		if attack_sfx.is_playing() != true:
			attack_sfx.pitch_scale = randf_range(1.0, 1.8)
			attack_sfx.play(0.0)
		
		print(str(name) + "hurt  " + str(body.name))
	pass


func hurt(damage, damage_type):
	var hurt_sfx = $SFX/HurtSFX
	
	
	print(name + "    got hurt")
	
	if TROOPSTATS.health >= 1:
		TROOPSTATS.health -= damage
		print(str(TROOPSTATS.health))
		$BloodFX.restart()
		
	else:
		death()
	
	pass
	

func death():
	
	print(name + "  died")
	
	GlobalHiveMind.enemies_gold_coins += 50
	GlobalHiveMind.friendly_troops_names.erase(self.name)
	$SFX/DeathSFX.play(0.0)
	$GoopVfx.restart()
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
	pass
	




func cancel_attack(body):
	if body.is_in_group("Enemy"):
		canAttack = false
		attack_timer.stop()
	pass # Replace with function body.


func _on_visiblility_radius_body_entered(body):
	if body.is_in_group("Enemy"):
			if body.transform.origin.distance_to(transform.origin) < transform.origin.distance_to(body.transform.origin):
					movement_target_position = body.transform.origin
					look_at(body.transform.origin)
					set_movement_target(movement_target_position)
			else:
				movement_target_position = GlobalHiveMind.friendly_tower_heart_pos_array.front()
				set_movement_target(movement_target_position)
	pass # Replace with function body.
