extends CharacterBody2D

@onready var towerheart_animations = $TowerheartAnimations

@export var heart_color : Color = Color.AQUA

@export_enum('friendly', 'hostile') var heart_faction = "friendly"

@export var TOWERSTATS = {
	'health' : 100, 
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_heart_faction()
	
	towerheart_animations.play("Idle")
	$Sprites/Heart.modulate = heart_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_heart_faction():
	
	match heart_faction:
		"friendly" :
			GlobalHiveMind.friendly_tower_heart_pos_array.append(global_transform.origin)
			add_to_group("Player")

		"hostile" :
			GlobalHiveMind.enemy_heart_pos_array.append(global_transform.origin)
			add_to_group("Enemy")
			
		
	pass

func hurt(damage, damage_type):
	
	if TOWERSTATS.health > 0:
		TOWERSTATS.health -= damage
		towerheart_animations.play("Hurt")
		print('hurt enemy tower')
	else:
		death_of_the_tower()
		
	pass
	

func death_of_the_tower():
	
	match heart_faction:
		"friendly":
			print('you lost')
			await get_tree().create_timer(5.0).timeout
			get_tree().change_scene_to_file('res://Main/K9/Lvls/main_menu.tscn')
		"hostile" :
			print('you won!')
			await get_tree().create_timer(5.0)
			get_tree().change_scene_to_file('res://Main/K9/Lvls/main_menu.tscn')
	pass
	
