extends CharacterBody2D


@onready var navigation_agent = $NavigationAgent2D
@onready var friendly_anim = $FriendlyAnim


@export var FRIENDLYSTATS = {
	'health' : 100.00,
	'walk_speed' : 100.0,
	'damage' : 5,
	
}

var target_pos : Vector2

#func _ready():
	#navigation_agent.target_position = GlobalHiveMind.enemy_heart_pos
	#
	#
	#pass
	#
#
#func _process(delta):
	#if velocity.x or velocity.y != 0:
		#friendly_anim.play("Walk")
	#else:
		#friendly_anim.play("Idle")
	#pass
	#
#
#func _physics_process(delta):
	#
	#if navigation_agent.navigation_finished:
		#navigation_agent.target_position = GlobalHiveMind.enemy_heart_pos
	#
	#velocity.y = (navigation_agent.get_next_path_position().y - transform.origin.y) * FRIENDLYSTATS.walk_speed * delta
	#velocity.x = (navigation_agent.get_next_path_position().x - transform.origin.x) * FRIENDLYSTATS.walk_speed * delta
	#
	#look_at(navigation_agent.get_next_path_position())
	#
	#move_and_slide()
	#
	#pass


var movement_speed: float = 200.0
var movement_target_position: Vector2 = GlobalHiveMind.enemy_heart_pos

#@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 40.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

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
