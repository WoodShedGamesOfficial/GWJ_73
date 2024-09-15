extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var melee_hitbox = $MeleeHitbox

@export var WEAPON_STATS = {
	"damage" : 25,
	"attack_speed" : 1.25,
}

#function blocks

func _ready():
	
	
	pass
	


func _input(event):
	if Input.is_action_just_pressed("Attack"):
		animation_player.play("Swing", 0.0, 2.0, false)
	pass

func attack(body):
	if body.is_in_group("Enemy") and body.has_method("hurt"):
		var damage = WEAPON_STATS.damage
		var damage_type = "blunt"
		
		body.hurt(damage, damage_type)
		print(str(body) + " / "+ str(damage))
	
	pass
