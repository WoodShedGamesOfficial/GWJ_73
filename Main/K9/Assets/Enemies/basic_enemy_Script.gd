extends CharacterBody2D
class_name K9_basic_enemy
##@experimental

## description here

@export var ENEMY_STATS = {
	'health' : 25,
	'walk_speed' : 50.0,
	'damage' : 5,
	
}

@export_enum('blunt', 'sharp', 'fire', 'poison', 'ice') var damage_type = 'blunt'

@export var enemy_level : int = 1

@onready var navigation_agent = $NavigationAgent2D
@onready var attack_timer = $AttackTimer
@onready var enemy_anims = $EnemyAnims
@onready var sprites = $Sprites

var movement_target : Vector2

var canAttack : bool 
var isAttacking : bool

#var movement_target_position: Vector2 

var attackingPlayer : bool

var seesEnemy : bool
var current_enemy
# function blocks

#@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	#navigation_agent.path_max_distance = 40.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	add_to_group("Enemy")
	
	if GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
		movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
	else:
		print("there are no Player towers")
	
	
	ENEMY_STATS.health = randi_range(50, (100 * enemy_level))
	ENEMY_STATS.damage = (ENEMY_STATS.damage * enemy_level / 2)
	
	$AttackTimer.connect('timeout', attack)
	$AttackTimer.start()
	
	pass
	

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target)
	
	pass
	

func set_movement_target(movement_target: Vector2):
	
	navigation_agent.target_position = movement_target
	
	pass
	

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	if seesEnemy:
		movement_target = current_enemy.transform.origin
	else:
		movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
	
	velocity = current_agent_position.direction_to(next_path_position) * ENEMY_STATS.walk_speed
	
	
	move_and_slide()
	
	pass
	

func _process(delta):
	
	
	if velocity != Vector2.ZERO:
		enemy_anims.play("Walk")
		#sprites.look_at(navigation_agent.get_next_path_position())
	else:
		enemy_anims.play("Idle")
	
	
	var target = $DetectCast.get_collider()
	
	if target != null and target.is_in_group("Player"):
		movement_target = target.transform.origin
		set_movement_target(movement_target)
		look_at(movement_target)
	if target == null:
		movement_target = GlobalHiveMind.enemy_heart_pos_array.front()
	
	
	pass
	

func hurt(damage, damage_type):
	
	if ENEMY_STATS.health > 0:
		ENEMY_STATS.health -= damage
		$BloodFX.restart()
		$HurtGrunt.pitch_scale = randf_range(.80, 1.5)
		$HurtGrunt.play(0.0)
		#var blood_i = blood_splat_p.instantiate()
	#
		#get_tree().current_scene.add_child(blood_i)
		#blood_i.transform.origin = transform.origin
	else:
		death()
	pass
	
  
var blood_splat_p = load('res://Main/K9/Assets/Fx/bloodsplat.tscn')

func death():
	var blood_i = blood_splat_p.instantiate()
	var chance_to_scream = randf_range(0,100)
	
	$CollisionShape2D.disabled = true
	DisableMode.DISABLE_MODE_MAKE_STATIC
	
	get_tree().current_scene.add_child(blood_i)
	blood_i.transform.origin = transform.origin
	if chance_to_scream >= 95:
		$DeathHowl.stream = preload("res://Main/K9/Assets/Audio/SFX/Whilhelm_Scream.wav")
	
	$DeathHowl.pitch_scale = randf_range(.90, 1.5)
	$DeathHowl.play(0.0)
	await get_tree().create_timer(0.75).timeout
	GlobalHiveMind.players_gold_coins += 25
	queue_free()
	pass
	
	
func prepare_attack(body):
	
	if body.is_in_group("Player"):
		canAttack = true
		$AttackTimer.start()
		
		#attack(body)

	pass
	
func cancel_attack(body):
	if body.is_in_group("Player"):
		canAttack = false
		attack_timer.stop()
	pass



func attack(body):
	var damage = ENEMY_STATS.damage
	
	if body.is_in_group("Player") or body.is_in_group("Troop") and body.has_method('hurt') and canAttack == true:
		body.hurt(damage, damage_type)
		$SwordClang.pitch_scale = randf_range(.90, 1.5)
		$SwordClang.play(0.0)
		print("enemy attacked:  " + str(body.name))
	
	
	pass
	

#enemies can see player and troops
func _on_player_visibility_area_body_entered(body):
	if body.is_in_group("Player"):
		movement_target = body.transform.origin
		attackingPlayer = true
		set_movement_target(movement_target)
		print(str(movement_target))
	
	pass # Replace with function body.


func _on_player_visibility_area_body_exited(body):
	
	if body.is_in_group("Player") or body.is_in_group("Troop"):
		movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
		set_movement_target(movement_target)
		
	pass # Replace with function body.


func _on_hit_box_body_entered(body):
	pass # Replace with function body.
