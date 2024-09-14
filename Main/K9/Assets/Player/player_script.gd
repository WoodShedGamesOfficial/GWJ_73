extends CharacterBody2D
class_name K9_player_controller


@onready var player_cam = $PlayerCam



@export var PLAYER_STATS = {
	'health' : 100.00,
	'walk_speed' : 300,
	'jump_height' : 400
}


# function blocks ->

func _ready():
	GlobalHiveMind.player_pos = global_position
	add_to_group("Player")
	pass
	

func _process(delta):
	
	GlobalHiveMind.player_pos = global_position
	
	
	pass
	

func _physics_process(delta):
	look_at(get_global_mouse_position())
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
		#velocity.y =  (-1 * PLAYER_STATS.jump_height)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var dir_x = Input.get_axis("ui_left", "ui_right")
	var dir_y = Input.get_axis("ui_up", "ui_down")
	
	if dir_x:
		velocity.x = dir_x * PLAYER_STATS.walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, PLAYER_STATS.walk_speed)
	
	if dir_y:
		velocity.y = dir_y * PLAYER_STATS.walk_speed
	else:
		velocity.y = move_toward(velocity.y, 0, PLAYER_STATS.walk_speed)
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
	
	player_cam.zoom.x = clamp(player_cam.zoom.x, 0.5, 2)
	player_cam.zoom.y = clamp(player_cam.zoom.y, 0.5, 2)
	
	
	pass
	
