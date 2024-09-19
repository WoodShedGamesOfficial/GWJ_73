extends CharacterBody2D

@onready var towerheart_animations = $TowerheartAnimations

@export var heart_color : Color = Color.AQUA

@export_enum('friendly', 'hostile') var heart_faction = "friendly"

@export var TOWERSTATS = {
	'health' : 100, 
}

var canContinue : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/WinLoseScreen.visible = false
	
	$HealthBar.max_value = TOWERSTATS.health
	$HealthBar.value = TOWERSTATS.health
	
	$HealthBar/Label.text = str(TOWERSTATS.health)
	
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
			GlobalHiveMind.friendly_tower_heart_pos_array.append(global_transform.origin)
			add_to_group("Player")

		"hostile" :
			GlobalHiveMind.enemy_heart_pos_array.append(global_transform.origin)
			add_to_group("Enemy")
			
		
	pass

func _input(event):
	var MM_path = load("res://Main/K9/Lvls/main_menu.tscn")
	
	if canContinue and Input.is_anything_pressed():
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_packed(MM_path)
		
	pass
	

func hurt(damage, damage_type):
	
	if TOWERSTATS.health >= 1:
		TOWERSTATS.health -= damage
		towerheart_animations.play("Hurt")
		$HealthBar.value = TOWERSTATS.health
		$HealthBar/Label.text = str(TOWERSTATS.health)
		print('hurt enemy tower')
	else:
		death_of_the_tower()
		
	pass
	

func death_of_the_tower():
	$HealthBar.visible = false
	var MM_path = load("res://Main/K9/Lvls/main_menu.tscn")
	
	
	match heart_faction:
		"friendly":
			$CanvasLayer/WinLoseScreen.update_stats_panel()
			$CanvasLayer/WinLoseScreen.visible = true
			$CanvasLayer/WinLoseScreen/PanelContainer/WinLoseLabel.text = "you got your ass kicked bro"
			await get_tree().create_timer(5.0).timeout
			$CanvasLayer/WinLoseScreen/Continue.visible = true
			canContinue = true
			#print('you lost')
		"hostile" :
			$CanvasLayer/WinLoseScreen.update_stats_panel()
			$CanvasLayer/WinLoseScreen.visible = true
			$CanvasLayer/WinLoseScreen/PanelContainer/WinLoseLabel.text = "you destroyed their Tower!"
			await get_tree().create_timer(5.0).timeout
			$CanvasLayer/WinLoseScreen/Continue.visible = true
			canContinue = true
			#print('you won!')
	#$CanvasLayer/WinLoseScreen.visible = true
	$CanvasLayer/WinLoseScreen.update_stats_panel()
	pass
	
