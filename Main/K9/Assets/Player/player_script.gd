extends CharacterBody2D
class_name K9_player_controller


@onready var player_cam = $PlayerCam
@onready var player_anim = $PlayerAnim



@export var PLAYER_STATS = {
	'health' : 100.00,
	'walk_speed' : 300,
	"base_gold" : 500,
	
}

var isSprinting : bool

# function blocks ->

func _ready():
	GlobalHiveMind.player_pos = global_position
	add_to_group("Player")
	add_to_group("Teleportable")
	
	GlobalHiveMind.players_gold_coins = PLAYER_STATS.base_gold
	pass
	

func _process(delta):
	isSprinting = Input.is_action_pressed("Sprint")
	
	GlobalHiveMind.player_pos = global_position
	
	if velocity.x or velocity.y != 0:
		player_anim.play("Walk")
		$Footsteps.playing = true
		#await $Footsteps.finished
		#$Footsteps.pitch_scale = randf_range(.9, 1.5)
	else:
		player_anim.play("Idle")
		$Footsteps.playing = false
	
	$GUI/Label.text = str(GlobalHiveMind.players_gold_coins)
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
	
	print('player has died')
	
	pass
