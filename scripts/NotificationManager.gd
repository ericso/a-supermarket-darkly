extends Node

# settings for notification tab
var notifications_container: VBoxContainer = null
@export var max_notifications = 100

# settings for toast
var toast_panel: Panel = null
var toast_container: VBoxContainer = null
@export var toast_lifetime: float = 3.0 # seconds before fading
@export var toast_fade_time: float = 1.0
@export var max_toasts: int = 1

func _ready():
	notifications_container = get_tree().current_scene.get_node_or_null("UI/MenuPanel/VBoxContainer/Content/Tabs/Notifications/ScrollContainer/VBoxContainer")
	toast_panel = get_tree().current_scene.get_node_or_null("UI/ToastContainer")
	toast_container = get_tree().current_scene.get_node_or_null("UI/ToastContainer/VBoxContainer")

func add_notification(message: String):
	if notifications_container == null:
		push_warning("notifications container not assigned")
		return
	
	var label = Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	notifications_container.add_child(label, true) # add to the top
	
	if notifications_container.get_child_count() > max_notifications:
		# remove the bottom notification, since we're adding to top
		notifications_container.get_child(notifications_container.get_child_count() - 1).queue_free()

func add_toast(message: String):
	if toast_panel == null or toast_container == null:
		push_warning("toast panel/container not assigned")
		return
	
	toast_panel.visible = true
	
	var label = Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	toast_container.add_child(label)
	
	# Limit max number of visible toasts
	if toast_container.get_child_count() > max_toasts:
		toast_container.get_child(0).queue_free()
	
	# Start fade and removal
	var tween = label.create_tween()
	tween.tween_interval(toast_lifetime)
	tween.tween_property(label, "modulate:a", 0.0, toast_fade_time)
	tween.finished.connect(func():
		if is_instance_valid(label):
			label.queue_free()
		await get_tree().process_frame # wait for queue_free to take effect
		check_hide_panel()
	)

func check_hide_panel():
	print("DEBUG::check_hide_panel")
	if toast_container.get_child_count() == 0:
		print("DEBUG::get_child_count is zero")
		toast_panel.visible = false

func add_log_message(message: String):
	print("[LOG]: ", message)
