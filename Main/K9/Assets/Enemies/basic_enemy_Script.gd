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
	
	#$AttackTimer.connect('timeout', attack)
	#$AttackTimer.start()
	#$AttackRadius.connect("body_entered", attack)
	$AttackRadius.connect('body_entered', prepare_attack)
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
		set_movement_target(movement_target)
	elif GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
		movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
		set_movement_target(movement_target)
	
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
	if target == null and GlobalHiveMind.friendly_tower_heart_pos_array.is_empty() != true:
		movement_target = GlobalHiveMind.enemy_heart_pos_array.front()
		set_movement_target(movement_target)
	
	
	for body in $AttackRadius.get_overlapping_bodies():
		if body != null:
			if body.is_in_group("Player") and $AttackTimer.is_stopped():
				$AttackTimer.start(0.0)
				look_at(body.transform.origin)
				await $AttackTimer.timeout
				attack(body)
				movement_target = transform.origin + Vector2(randf_range(50.0, 100.0), randf_range(50.0, 100.0))  
				set_movement_target(movement_target)
				await get_tree().create_timer(3.0).timeout
				return
		
	
	pass
	

func hurt(damage, damage_type):
	var hurt_audio = $HURTAUDIOTEST
	var blood_i = blood_splat_p.instantiate()
	
	#=========
	
	if ENEMY_STATS.health > 0:
		
		ENEMY_STATS.health -= damage
		
		get_tree().current_scene.add_child(blood_i)
		blood_i.transform.origin = transform.origin
		
		$BloodFX.restart()
		$EnemyAnims.play("Hurt")
		
		hurt_audio.pitch_scale = randf_range(.80, 1.5)
		hurt_audio.play(0.0)
		
		await $EnemyAnims.animation_finished and hurt_audio.finished
		
		return
	else:
		death()
	pass
	
  
var blood_splat_p = load('res://Main/K9/Assets/Fx/bloodsplat.tscn')

func death():
	var death_howl = $DeathHowl
	var blood_i = blood_splat_p.instantiate()
	var chance_to_scream = randf_range(0,100)
	
	$CollisionShape2D.disabled = true
	DisableMode.DISABLE_MODE_MAKE_STATIC
	
	get_tree().current_scene.add_child(blood_i)
	blood_i.transform.origin = transform.origin
	
	if chance_to_scream >= 95:
		death_howl.stream = preload("res://Main/K9/Assets/Audio/SFX/Whilhelm_Scream.wav")
	
	death_howl.pitch_scale = randf_range(.90, 1.5)
	death_howl.play(0.0)
	await get_tree().create_timer(0.75).timeout
	GlobalHiveMind.players_gold_coins += 25
	queue_free()
	
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
	var damage = randi_range(ENEMY_STATS.damage, (ENEMY_STATS.damage * 2))
	var swords_clashing = $SwordClang
	
	if canAttack and body != null:    #body.has_method("hurt") and 
		body.hurt(damage, damage_type)
		print(str(name) + "hurt  " + str(body.name))
		if swords_clashing.is_playing() != true:
			swords_clashing.play()
	
	#for body in $HitBox.get_overlapping_bodies():
		#if body.is_in_group("Player") or body.is_in_group("Troop") and canAttack == true:
			##await get_tree().create_timer(randf_range(1.5, 3)).timeout
			#body.hurt(damage, damage_type)
			#$SwordClang.pitch_scale = randf_range(.90, 1.5)
			#$SwordClang.play(0.0)
			#print("enemy attacked:  " + str(body.name))
		#
	
	pass
	

#enemies can see player and troops
func _on_player_visibility_area_body_entered(body):
	
	if body.is_in_group("Player"):
		if body.transform.origin.distance_to(transform.origin) < transform.origin.distance_to(body.transform.origin):
				movement_target = body.transform.origin
				look_at(body.transform.origin)
				set_movement_target(movement_target)
		else:
			movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
			set_movement_target(movement_target)
		
		attackingPlayer = true
		#set_movement_target(movement_target)
		#print(str(movement_target))
	
	pass # Replace with function body.


func _on_player_visibility_area_body_exited(body):
	
	if body.is_in_group("Player") or body.is_in_group("Troop"):
		movement_target = GlobalHiveMind.friendly_tower_heart_pos_array.front()
		set_movement_target(movement_target)
		
	pass # Replace with function body.
