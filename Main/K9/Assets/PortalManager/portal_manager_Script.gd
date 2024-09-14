extends Node

var portal_location_array = []

func _ready():
	
	for p in $Portals.get_children():
		p.get_node_or_null("Area2D").connect('body_entered', teleport)
		portal_location_array.append(p.transform.origin)
	
	print(str(portal_location_array))
	
	
	
	pass
	

func teleport(body):
	
	if body.is_in_group("Player"):
		body.transform.origin = portal_location_array.pick_random()
		for p in $Portals.get_children():
			p.get_node_or_null("Area2D")["monitoring"] = false
	pass
	
