extends Node2D
class_name K9s_level_manager

@export var hiveminds_base_gold : int = 550

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalHiveMind.enemies_gold_coins = hiveminds_base_gold
	pass # Replace with function body.
