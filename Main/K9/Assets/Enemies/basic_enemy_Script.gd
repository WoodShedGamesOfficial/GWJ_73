extends CharacterBody2D
class_name K9_basic_enemy
##@experimental

## description here

@export var ENEMY_STATS = {
	'health' : 100,
	'walk_speed' : 300.0,
	'damage' : 25,
	
}

@export_enum('blunt', 'sharp', 'fire', 'poison', 'ice') var damage_type = 'blunt'

@onready var navigation_agent = $NavigationAgent2D
@onready var attack_timer = $AttackTimer

var movement_target : Vector2

var canAttack : bool 


# function blocks

#func _ready():
	#movement_target = GlobalHiveMind.enemy_heart_pos
	#
	#nav_agent.target_position = movement_target
	#
	#$NavTimer.connect('timeout', update_nav_agent)
	#$NavTimer.start()
	#
	#$PlayerVisibilityArea.connect("body_entered", focus_on_player)
	#$AttackRadius.connect("body_entered", prepare_attack)
	#$AttackRadius.connect("body_exited", cancel_attack)
	#
	#attack_timer.connect('timeout', prepare_attack)
	#
	#pass
	#
#
#func connect_signals():
	#$NavTimer.connect('timeout', update_nav_agent)
	#$NavTimer.start()
	#
	#$PlayerVisibilityArea.connect("body_entered", focus_on_player)
	#$AttackRadius.connect("body_entered", prepare_attack)
	#$AttackRadius.connect("body_exited", cancel_attack)
	##attack_timer.connect('timeout', attack)
	#pass
	#
#
#func _physics_process(delta):
	#
	#if nav_agent.navigation_finished:
		#nav_agent.target_position = GlobalHiveMind.friendly_tower_heart_pos
	#
	#velocity.y = (nav_agent.get_next_path_position().y - transform.origin.y) * ENEMY_STATS.walk_speed * delta
	#velocity.x = (nav_agent.get_next_path_position().x - transform.origin.x) * ENEMY_STATS.walk_speed * delta
	#
	#
	#
	#move_and_slide()
	#pass
	#
#
#func _process(delta):
	##if attack_timer.is_stopped() != true:
		##print("attacking player in :   " + str(attack_timer.time_left))
	#pass
	#
#
#func update_nav_agent():
	#
	##movement_target = GlobalHiveMind.player_pos
	#nav_agent.target_position = GlobalHiveMind.friendly_tower_heart_pos
	#
	#
	#pass
	#
#
#func focus_on_player():
	#
	#nav_agent.target_position = GlobalHiveMind.player_pos
	#
	#pass
	#
#
#func focus_on_tower_heart():
	#
	#nav_agent.target_position = GlobalHiveMind.enemy_heart_pos
	#pass
	#

func cancel_attack(body):
	if body.is_in_group("Player"):
		canAttack = false
		attack_timer.stop()
	pass

func prepare_attack(body):
	if body.is_in_group("Player"):
		canAttack = true
		
		if attack_timer.is_stopped():
			attack_timer.start(0.0)
			await attack_timer.timeout
			attack(body)
		
	pass
	

func attack(body):
	var damage = ENEMY_STATS.damage
	
	if body.is_in_group("Player") and body.has_method('hurt') and canAttack == true:
		body.hurt(damage, damage_type)
		print("attacked the player")
	
	
	pass
	


var movement_speed: float = 200.0
var movement_target_position: Vector2 = GlobalHiveMind.friendly_tower_heart_pos

#@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	add_to_group("Enemy")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func hurt(damage, damage_type):
	
	if ENEMY_STATS.health > 0:
		ENEMY_STATS.health -= damage
	else:
		death()
	pass
	
  
var blood_splat_p = load('res://Main/K9/Assets/Fx/bloodsplat.tscn')

func death():
	var blood_i = blood_splat_p.instantiate()
	
	get_tree().current_scene.add_child(blood_i)
	blood_i.transform.origin = transform.origin
	queue_free()
	pass
