class_name Door extends Node2D

func _ready():
	print("DEBUG:: door _ready")
	GroceryStore.register_door(self)
