class_name Product extends Node

var id: String = ""
var label: String = ""
var sale_price: float = 0.0
var unit_price: float = 0.0
var texture: CompressedTexture2D = null

func _init(
	_id: String,
	_label: String,
	_sale_price: float,
	_unit_price: float,
	_texture: CompressedTexture2D,
) -> void:
	self.id = _id
	self.label = _label
	self.sale_price = _sale_price
	self.unit_price = _unit_price
	self.texture = _texture
