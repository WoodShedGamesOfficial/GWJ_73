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
 "William", "Xander", "Yvette", "Zachary"
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
	$Label.text = name
	GlobalHiveMind.friendly_troops_names.append(name)
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	if GlobalHiveMind.enemy_heart_pos_array.is_empty() != true:
		movement_target_position = GlobalHiveMind.enemy_heart_pos_array.front()
	
	add_to_group("Player")
	add_to_group("Troop")
	
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
	
	sprites.look_at(navigation_agent.get_next_path_position())
	
	for body in $AttackRadius.get_overlapping_bodies():
		if body.is_in_group("Player") and $AttackTimer.is_stopped():
			$AttackTimer.start(0.0)
			look_at(body.transform.origin)
			await $AttackTimer.timeout
			attack(body)
		
	pass
	

func _process(delta):
	
	
	
	pass
	

func prepare_attack(body):
	
	if body.is_in_group("Player"):
		canAttack = true
		#$AttackTimer.start()
		
		#attack(body)

	pass
	
func cancel_attack(body):
	if body.is_in_group("Player"):
		canAttack = false
		attack_timer.stop()
	pass

func attack(body):
	var damage = TROOPSTATS.damage
	
	if canAttack and body != null:    #body.has_method("hurt") and 
		body.hurt(damage, damage_type)
		print(str(name) + "hurt  " + str(body.name))
	
	pass


func hurt(damage, damage_type):
	
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
	GlobalHiveMind.friendly_troops_names.erase(name)
	
	await get_tree().create_timer(1.0).timeout
	queue_free()
	
	pass
	
