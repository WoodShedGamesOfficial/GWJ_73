extends CharacterBody2D
class_name K9_basic_enemy
##@experimental

## description here

@export var ENEMY_STATS = {
	'health' : 100.00,
	'walk_speed' : 300.0,
}

@onready var nav_agent = $NavigationAgent2D

var movement_target : Vector2



# function blocks

func _ready():
	movement_target = GlobalHiveMind.enemy_heart_pos
	
	nav_agent.target_position = movement_target
	
	$NavTimer.connect('timeout', update_nav_agent)
	$NavTimer.start()
	
	$PlayerVisibilityArea.connect("body_entered", focus_on_player)
	$AttackRadius.connect("body_entered", attack)
	
	pass
	

func connect_signals():
	$NavTimer.connect('timeout', update_nav_agent)
	$NavTimer.start()
	
	$PlayerVisibilityArea.connect("body_entered", focus_on_player)
	$AttackRadius.connect("body_entered", attack)
	pass
	

func _physics_process(delta):
	
	#nav_agent.get_next_path_position()
	
	velocity.y = (nav_agent.get_next_path_position().y - transform.origin.y) * ENEMY_STATS.walk_speed * delta
	velocity.x = (nav_agent.get_next_path_position().x - transform.origin.x) * ENEMY_STATS.walk_speed * delta
	
	
	
	move_and_slide()
	pass
	


func update_nav_agent():
	
	#movement_target = GlobalHiveMind.player_pos
	nav_agent.target_position = GlobalHiveMind.player_pos
	
	
	pass
	

func focus_on_player():
	
	nav_agent.target_position = GlobalHiveMind.player_pos
	pass
	

func focus_on_tower_heart():
	
	nav_agent.target_position = GlobalHiveMind.enemy_heart_pos
	pass
	

func attack(body):
	
	if body.is_in_group("Player"):
		print("attacked the player")
	
	
	pass
	
