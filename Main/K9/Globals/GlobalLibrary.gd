extends Node

var level_path : PackedScene

var current_round : int

var hasSplashed : bool 

var fun_facts_array = [
	
	"The tallest tower in the world is the Burj Khalifa, standing at 2,717 feet tall!",
	"one of the oldest towers in the world was built around 10650 - 9650 BCE!",
	"Ophiocordyceps unilateralis is a type of predatory fungus that hijacks its hosts bodily functions",
	'You would have to build a tower 452.03 million miles high to reach the closest point in Jupiters Orbit.',
	"One 'Astronomical Unit' is roughly equivalent to: 92,955,807.267 imperial miles",
	"It's roughly 1,000 AU to the inner region of our solar system",
	"The deepest hole on earth is the Kora Superdeep Borehole, spanning 40,230ft deep with a rough 9 inch diameter",
	"Sơn Đoòng cave passage is the largest known cave passage in the world by volume... you could fit so much spaghetti in that",
	
	
	
]

var player_color : Color = Color.AQUA

var hostile_names_array = [
	"Oorak", 'Gishmael', "Fouda", "Igna", "Mornoeal", "GouraDoun"
]

var firendly_name_array = [
"Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Helen", "Ivan", "Jack",
 "Kate", "Leo", "Mia", "Noah", "Olivia", "Paul", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", 
"Vincent", "William", "Xander", "Yvette", "Zachary", "Abigail", "Benjamin", "Chloe", "Daniel", "Emily", 
"Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine", "Liam", "Maya", "Nathan", "Olivia", "Parker",
 "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent", "William", "Xander", "Yvette", "Zachary", "Abigail",
 "Benjamin", "Chloe", "Daniel", "Emily", "Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine", "Liam", "Maya",
 "Nathan", "Olivia", "Parker", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent", "William", "Xander", "Yvette",
 "Zachary", "Abigail", "Benjamin", "Chloe", "Daniel", "Emily", "Finn", "Gabrielle", "Harry", "Isla", "Jacob", "Katherine",
 "Liam", "Maya", "Nathan", "Olivia", "Parker", "Quinn", "Rachel", "Sarah", "Thomas", "Ursula", "Vincent",
 "William", "Xander", "Yvette", "Zachary", "SAGD", "DevinGD", "TQ", "Dutt"
]
