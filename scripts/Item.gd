class_name Item extends Node

var id: String = ""
var label: String = ""
var sale_price: float = 0.0
var texture: CompressedTexture2D = null
var unit_price: float = 0.0

func _init(
	_id: String,
	_label: String,
	_sale_price: float,
	_texture: CompressedTexture2D,
	_unit_price,
) -> void:
	self.id = _id
	self.label = _label
	self.sale_price = _sale_price
	self.texture = _texture
	self.unit_price = _unit_price
