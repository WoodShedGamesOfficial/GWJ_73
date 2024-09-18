extends CharacterBody2D
class_name K9_player_controller


@onready var player_cam = $PlayerCam
@onready var player_anim = $PlayerAnim



@export var PLAYER_STATS = {
	'health' : 100.00,
	'walk_speed' : 300,
	
}

@export var base_gold : int = 150

var isSprinting : bool

#respawning
var respawn_location : Vector2

# function blocks ->

func _ready():
	GlobalHiveMind.player_pos = global_position
	add_to_group("Player")
	add_to_group("Teleportable")
	add_to_group('friendly')
	
	GlobalHiveMind.players_gold_coins = base_gold
	
	#$GUI/Label.text = str(GlobalHiveMind.players_gold_coins)
	$GUI/HUD/HP_Bar.max_value = PLAYER_STATS.health
	respawn_location = transform.origin
	
	
	pass
	

func _process(delta):
	var footstep_audio = $Footsteps
	
	isSprinting = Input.is_action_pressed("Sprint")
	
	GlobalHiveMind.player_pos = global_position
	
	if velocity.x or velocity.y != 0:
		player_anim.play("Walk")
		if footstep_audio.is_playing() != true:
			footstep_audio.playing = true
		#await $Footsteps.finished
		#$Footsteps.pitch_scale = randf_range(.9, 1.5)
	else:
		player_anim.play("Idle")
		footstep_audio.playing = false
	
	
	#$GUI/Label.text = str(GlobalHiveMind.players_gold_coins)
	pass
	

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	var dir_x = Input.get_axis("ui_left", "ui_right")
	var dir_y = Input.get_axis("ui_up", "ui_down")
	
	if dir_x:
		velocity.x = dir_x * PLAYER_STATS.walk_speed
		if isSprinting:
			velocity.x = dir_x * (PLAYER_STATS.walk_speed * 1.75)
		#player_anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, PLAYER_STATS.walk_speed)
		#player_anim.play("Idle")
	if dir_y:
		velocity.y = dir_y * PLAYER_STATS.walk_speed
		if isSprinting:
			velocity.y = dir_y * (PLAYER_STATS.walk_speed * 1.75)
		#player_anim.play("Walk")
	else:
		velocity.y = move_toward(velocity.y, 0, PLAYER_STATS.walk_speed)
		#player_anim.play("Idle")
	
	#velocity = velocity.normalized()
	
	#if velocity != Vector2.ZERO:
		#print(str(velocity))
	
	move_and_slide()
	
	pass
	

func _input(event):
	
	
	
	#zoom in-out
	var zoom_step : float = 0.05
	
	if Input.is_action_just_pressed("Wheel_down"):
		player_cam.zoom.x -= zoom_step
		player_cam.zoom.y -= zoom_step
	elif Input.is_action_just_pressed("Wheel_up"):
		player_cam.zoom.x += zoom_step
		player_cam.zoom.y += zoom_step
	
	player_cam.zoom.x = clamp(player_cam.zoom.x, 0.20, 1.5)
	player_cam.zoom.y = clamp(player_cam.zoom.y, 0.20, 1.5)
	
	
	pass
	

func hurt(damage, damage_type):
	
	if PLAYER_STATS.health > 0:
		PLAYER_STATS.health -= damage
	else:
		player_death()
	
	#match damage_type:
		#'blunt' :
			#print("Uga dugga  " + str(damage_type))
		#"sharp" :
			#print("bleeding  " + str(damage_type))
	
	print("took damage : " + str(damage) + "  /  " + str(damage_type) + "current health" + str(PLAYER_STATS.health))
	pass
	

func player_death():
	transform.origin = respawn_location
	GlobalHiveMind.players_gold_coins -= (GlobalHiveMind.players_gold_coins / 2)
	print('player has died')
	
	pass
