class_name PortalManager
extends Node

var portal_array = []

func _ready():
	for p in $Portals.get_children():
		p.connect('teleport_requested', teleport)
		portal_array.append(p)


func teleport(body: Node2D, from_portal: Portal, to_portal: Portal):

	var receiving_portal : Portal

	# If we've provided a target portal, use that
	if to_portal:
		receiving_portal = to_portal

	# Otherwise, pick a random portal
	else: 
		# This will first filter out the current portal and then pick a random neutral portal
		receiving_portal = portal_array.filter(func(p): return p != from_portal and p.faction == "neutral").pick_random()
	
	# This adds the body to the receiving portal to prevent teleportation loops
	receiving_portal.receive_teleport_body(body)

	# Teleport the body
	body.transform.origin = receiving_portal.transform.origin
