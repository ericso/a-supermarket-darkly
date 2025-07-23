class_name Item extends Node

var id: String = ""
var label: String = ""
var price: int = 0 # TODO change this to float
var icon: CompressedTexture2D = null

func _init(_id: String, _label: String, _price: int, icon: CompressedTexture2D) -> void:
	self.id = _id
	self.label = _label
	self.price = _price
	self.icon = icon
