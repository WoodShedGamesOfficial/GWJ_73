class_name Portal
extends Node2D

## Set the portal this portal will teleport to.
@export var linked_portal : Portal

## Setting the portal as bidirectional will allow for navAgents to know how to use portals in both directions.
@export var is_bidirectional := false

## If the portal is neutral, it can be used by any unit in the "Teleportable" group, otherwise the unit must be in the "Teleportable" group AND the "friendly" or "hostile" group.
@export_enum("friendly","hostile","neutral") var faction = "neutral"

signal teleport_requested(body: Node2D, from_portal: Portal, to_portal: Portal)


@onready var portal_area : Area2D = %PortalArea
@onready var nav_link : NavigationLink2D = %NavigationLink2D


var bodies_in_area : Array[Node2D] = []


func _ready():
	nav_link.bidirectional = is_bidirectional

	nav_link.set_global_start_position(transform.origin)

	if linked_portal:
		nav_link.set_global_end_position(linked_portal.transform.origin)

	match faction:
		"friendly":
			nav_link.set_navigation_layer_value(1, true)
		"hostile":
			nav_link.set_navigation_layer_value(2, true)
		"neutral":
			nav_link.set_navigation_layer_value(1, true)
			nav_link.set_navigation_layer_value(2, true)


func receive_teleport_body(body: Node2D):
	# Prevent teleporting multiple times - called from manager
	if bodies_in_area.has(body):
		return
	
	bodies_in_area.append(body)


func _on_portal_area_body_entered(body:Node2D):
	# Prevent teleporting multiple times
	if bodies_in_area.has(body) or !body.is_in_group("Teleportable"):
		return

	if faction == "neutral" or body.is_in_group(faction):
		bodies_in_area.append(body)
		teleport_requested.emit(body, self, linked_portal)


func _on_portal_area_body_exited(body:Node2D):
	if bodies_in_area.has(body):
		bodies_in_area.erase(body)
