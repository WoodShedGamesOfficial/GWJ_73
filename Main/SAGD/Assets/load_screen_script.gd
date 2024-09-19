extends Control

var level_path = GlobalLibrary.level_path

var canPlay : bool

func _ready():
	
	
	pass
	

func _input(event):
	if Input.is_anything_pressed():
		queue_free()
	pass
