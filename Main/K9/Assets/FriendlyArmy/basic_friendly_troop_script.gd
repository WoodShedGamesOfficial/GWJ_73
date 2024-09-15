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


var movement_speed: float = 200.0
var movement_target_position : Vector2

@onready var sprites = $Sprites

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
	pass
	

func hurt(damage, damage_type) -> int:
	if TROOPSTATS.health > 0:
		TROOPSTATS.health -= damage
		$BloodFX.restart()
	else:
		death()
	
	return TROOPSTATS.health
	

func death():
	
	print(name + "  died")
	
	GlobalHiveMind.enemies_gold_coins += 50
	GlobalHiveMind.friendly_troops_names.erase(name)
	
	queue_free()
	
	pass
	
