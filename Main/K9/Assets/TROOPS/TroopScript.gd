extends CharacterBody2D
class_name K9s_Troop_creator
##@experimental
##trying to simplify and replace Friendly/hostile troop code to unscrew the AI behavior


@export_enum("friendly", "hostile") var faction = 'friendly'

@export var TROOP_STATS = {
	'health' : 25,
	'walk_speed' : 100.00,
	'base_damage' : 5,
}

@export_enum('blunt', "fire", 'poison', 'ice', 'sharp') var damage_type = 'sharp'

func _ready():
	assign_faction()
	
	pass
	

func assign_faction():
	
	match faction:
		"friendly" : 
			add_to_group('friendly') # Grouping for behavioral reasons
			add_to_group('teleportable') # Grouping for behavioral reasons
			
			$Sprites/Head.modulate = GlobalLibrary.player_color #Color Coding
			$Sprites/Feet.modulate = GlobalLibrary.player_color  #Color Coding
			
			set_collision_layer_value(5, true) # assigned to friendly troop layer
			set_collision_mask_value(2, true)#detects enemy groups
			
		'hostile' : 
			add_to_group("enemy") # Grouping for behavioral reasons
			add_to_group('teleportable') # Grouping for behavioral reasons
			
			$Sprites/Head.modulate = Color.DARK_RED #Color Coding
			$Sprites/Feet.modulate = Color.DARK_RED #Color Coding
			
			set_collision_layer_value(2, true) #is assigned to the enemy layer
			set_collision_mask_value(5, true) #detects players/ friendly troops
			set_collision_mask_value(1, true) #detect player
			
	pass
	
