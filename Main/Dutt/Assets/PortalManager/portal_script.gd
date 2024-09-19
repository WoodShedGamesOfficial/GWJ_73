class_name Portal
extends Node2D

## The portal this portal will teleport to.
@export var linked_portal : Portal


@onready var portal_area : Area2D = %PortalArea


var bodies_in_area : Array[Node2D] = []
			

func _ready():
	if !linked_portal:
		print(self.name + " is missing linked portal!")


func receive_teleport_body(body : Node2D):
	if bodies_in_area.has(body):
		return
	
	bodies_in_area.append(body)

	# Teleport the body
	body.transform.origin = transform.origin


func _on_portal_area_body_entered(body : Node2D):
	# Prevent teleporting multiple times
	if bodies_in_area.has(body) or !body.is_in_group("Teleportable"):
		return

	if body.is_in_group("Teleportable"):
		bodies_in_area.append(body)
		linked_portal.receive_teleport_body(body)


func _on_portal_area_body_exited(body : Node2D):
	if bodies_in_area.has(body):
		bodies_in_area.erase(body)