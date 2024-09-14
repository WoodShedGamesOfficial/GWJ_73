extends Node2D

@onready var towerheart_animations = $TowerheartAnimations

@export var heart_color : Color = Color.AQUA

@export_enum('friendly', 'hostile') var heart_faction = "friendly"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_heart_faction()
	
	towerheart_animations.play("Idle")
	$Sprites/Heart.modulate = heart_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_heart_faction():
	
	match heart_faction:
		"friendly" :
			GlobalHiveMind.friendly_tower_heart_pos = global_transform.origin
		"hostile" :
			GlobalHiveMind.enemy_heart_pos = global_transform.origin
		
	pass
