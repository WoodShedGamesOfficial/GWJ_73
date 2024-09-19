extends CanvasLayer

@onready var hp_bar = $HUD/HP_Bar
@onready var coin_label = $HUD/HBoxContainer/Label
@onready var player_0 = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	coin_label.text = str(GlobalHiveMind.players_gold_coins)
	$HUD/HP_Bar.value = player_0.PLAYER_STATS['health']
	
	$HUD/TroopsLabel.text =("Troops:  " + str(GlobalHiveMind.friendly_troop_count.size()))
	pass
