extends Node

var portal_location_array = []

func _ready():
	
	for p in $Portals.get_children():
		p.get_node_or_null("Area2D").connect('body_entered', teleport)
		p.get_node_or_null("Area2D").connect('body_exited', _on_area_2d_body_exited)
		portal_location_array.append(p.transform.origin)
	
	print("Portal locations" + str(portal_location_array))
	
	
	
	pass
	

func teleport(body):
	
	if body.is_in_group("Player"):
		body.transform.origin = portal_location_array.pick_random()
		for p in $Portals.get_children():
			p.get_node_or_null("Area2D")["monitoring"] = false
	
	pass
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		teleport(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	for p in $Portals.get_children():
		p.get_node_or_null("Area2D")["monitoring"] = true
	pass # Replace with function body.
