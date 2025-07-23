class_name Item extends Node

var id: String = ""
var label: String = ""
var price: float = 0.0
var texture: CompressedTexture2D = null

func _init(_id: String, _label: String, _price: float, _texture: CompressedTexture2D) -> void:
	self.id = _id
	self.label = _label
	self.price = _price
	self.texture = _texture
