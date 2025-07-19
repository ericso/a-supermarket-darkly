extends Node2D

@export var item_name: String
@export var price: int
@export var icon: Texture2D

@onready var sprite := $Sprite

func _ready():
	sprite.texture = icon
