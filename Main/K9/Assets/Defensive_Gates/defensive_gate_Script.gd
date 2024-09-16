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
			
	
	$health.text = str(gate_health)
	pass

func hurt(damage, damage_type):
	
	if gate_health >= 1:
		gate_health -= damage
		$health.text = str(gate_health)
		$DustFX.restart()
	else:
		destroy_gate()
	pass
	

func destroy_gate():
	#if get_tree().current_scene.get_node_or_null("NavigationRegion2D") != null:
		#get_tree().current_scene.get_node_or_null("NavigationRegion2D").bake_navigation_polygon()
	
	queue_free()
	pass
