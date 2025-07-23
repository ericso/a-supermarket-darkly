class_name Item extends Node2D

@export var item_name: String
@export var price: int
@export var icon: Texture2D

@onready var sprite := $Sprite

func _init(name, price, icon) -> void:
	item_name = name
	price = price
	sprite.texture = icon
