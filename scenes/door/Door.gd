class_name Door extends Node2D

func _ready():
	StoreManager.register_door(self)
