class_name Portal
extends Node2D


signal teleport_requested(body: Node2D, portal: Portal)


@onready var portal_area : Area2D = %PortalArea
	

var bodies_in_area : Array[Node2D] = []


func receive_teleport_body(body: Node2D) -> void:
	# Prevent teleporting multiple times - called from manager
	if bodies_in_area.has(body):
		return
	
	bodies_in_area.append(body)


func _on_portal_area_body_entered(body:Node2D) -> void:
	# Prevent teleporting multiple times
	if bodies_in_area.has(body):
		return

	bodies_in_area.append(body)
	teleport_requested.emit(body, self)


func _on_portal_area_body_exited(body:Node2D) -> void:
	if bodies_in_area.has(body):
		bodies_in_area.erase(body)
