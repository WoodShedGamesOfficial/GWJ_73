extends CharacterBody2D


@export var gate_health : int = 1000


@export_enum("friendly", "hostile") var faction = "friendly"

func _ready():
	
	match faction:
		"friendly" :
			add_to_group("Troop")
			set_collision_mask_value(2, true)
			set_collision_layer_value(5, true)
			#collision_mask != 5
		"hostile" : 
			add_to_group("Enemy")
			set_collision_mask_value(5, true)
			set_collision_layer_value(2, true)
			
	
	pass

func hurt(damage, damage_type) -> int:
	
	if gate_health > 0:
		gate_health -= damage
		$DustFX.restart()
	else:
		destroy_gate()
	return gate_health
	

func destroy_gate():
	if get_tree().current_scene.get_node_or_null("NavigationRegion2D") != null:
		get_tree().current_scene.get_node_or_null("NavigationRegion2D").bake_navigation_polygon()

	pass
