extends Node2D

@onready var store_map: TileMapLayer = $Store
@onready var money_label := $UI/MarginContainer/PanelContainer/Money

func _ready():
	$UI/MenuPanel.hide()
	$UI/ButtonContainer/MenuButton.pressed.connect(on_menu_button_pressed)
	
	spawn_interactables()
	
	InventoryManager.populate_inventory()

func _process(_delta):
	update_money_label()

# spawn_interactables instantiates all "interactable" tiles
func spawn_interactables():
	if store_map == null:
		push_error("store tilemaplayer node not found")
	
	for cell in store_map.get_used_cells():
		var tile_data = store_map.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("interactable"):
			var scene_path := tile_data.get_custom_data("scene_path") as String
			if scene_path != "":
				var packed_scene := load(scene_path)
				if packed_scene:
					var node = packed_scene.instantiate()
					node.position = store_map.map_to_local(cell)
					add_child(node)
					node.name = tile_data.get_custom_data("name")
				else:
					push_error("⚠️ Could not load scene at path: ", scene_path)

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves

func on_menu_button_pressed():
	var menu = $UI/MenuPanel
	menu.refresh_tabs()
	menu.popup_centered()
