class_name PortalManager
extends Node

var portal_array = []

func _ready():
	for p in $Portals.get_children():
		p.connect('teleport_requested', teleport)
		portal_array.append(p)


func teleport(body: Node2D, portal: Duffs_Portals):
	# Don't do anything if the body isn't teleportable
	if !body.is_in_group("Teleportable"):
		return

	# This will first filter out the current portal and then pick a random portal
	var random_portal = portal_array.filter(func(p): return p != portal).pick_random()

	# This adds the body to the random portal to prevent teleportation loops
	random_portal.receive_teleport_body(body)

	# Teleport the body
	body.transform.origin = random_portal.transform.origin
