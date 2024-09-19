extends Node2D


var DICTIONARYMOTHERFUCKER = {
	1 : "The Devil Wears Parada",
	2 : "Harry Porker and the slambers of cheekrekts",
	3 : {"another fuckin dictionary" : "its OVER NINE THOUSAAAAAAND"},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(str(DICTIONARYMOTHERFUCKER[3]["another fuckin dictionary"]))
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
