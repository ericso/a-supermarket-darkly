class_name Item extends Node

@export var id: String
@export var label: String
@export var price: int

@onready var sprite := $Sprite

var icon_path: String = ""

func _init(id: String, label: String, price: int, icon_path: String) -> void:
	id = id
	label = label
	price = price
	icon_path = icon_path

func _ready():
	sprite.texture = icon_path
