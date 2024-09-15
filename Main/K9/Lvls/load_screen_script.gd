extends Control

var level_path = GlobalLibrary.level_path

var canPlay : bool

func _ready():
	var level_i = level_path.instantiate()
	
	get_tree().root.add_child(level_i)
	await get_tree().create_timer(3.0).timeout
	$AnyButton.visible = true
	
	pass
	

func _input(event):
	if Input.is_anything_pressed():
		queue_free()
	pass
