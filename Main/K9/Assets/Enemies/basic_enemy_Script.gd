extends CharacterBody2D
class_name K9_basic_enemy
##@experimental



@export var ENEMY_STATS = {
	'health' : 100.00,
	'walk_speed' : 1.10,
}

@onready var nav_agent = $NavigationAgent2D


var movement_target : Vector2

# function blocks

func _ready():
	movement_target = GlobalHiveMind.player_pos
	
	nav_agent.target_position = movement_target
	
	$NavTimer.connect('timeout', update_nav_agent)
	$NavTimer.start()
	
	pass
	

func _physics_process(delta):
	
	#nav_agent.get_next_path_position()
	
	velocity = (nav_agent.get_next_path_position() - global_position) * ENEMY_STATS.walk_speed
	#velocity.x = (nav_agent.get_next_path_position() - global_position.x) * ENEMY_STATS.walk_speed
	
	
	move_and_slide()
	pass
	

func update_nav_agent():
	
	#movement_target = GlobalHiveMind.player_pos
	nav_agent.target_position = GlobalHiveMind.player_pos
	
	
	pass
	
