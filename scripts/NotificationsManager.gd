extends Node

# settings for notification tab
@onready var notifications_tab = $Main/UI/MenuPanel/VBoxContainer/Content/Tabs/Notifications/ScrollContainer/VBoxContainer
@export var max_notifications = 100

# settings for toast
@onready var toast_container = $Main/UI/ToastContainer
@export var toast_lifetime: float = 3.0 # seconds before fading
@export var toast_fade_time: float = 1.0
@export var max_toasts: int = 2

func add_notification(message: String):
	var label = Label.new()
	label.text = message
	label.autowrap = true
	notifications_tab.add_child(label, true) # add to the top
	
	if notifications_tab.get_child_count() > max_notifications:
		# remove the bottom notification, since we're adding to top
		notifications_tab.get_child(notifications_tab.get_child_count() - 1).queue_free()

func add_toast(message: String):
	var label = Label.new()
	label.text = message
	label.autowrap = true
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_container.add_child(label)
	
	# Limit max number of visible toasts
	if toast_container.get_child_count() > max_toasts:
		toast_container.get_child(0).queue_free()
	
	# Start fade and removal
	var tween = toast_container.create_tween()
	tween.tween_interval(toast_lifetime)
	tween.tween_property(label, "modulate:a", 0.0, toast_fade_time)
	tween.finished.connect(func(): label.queue_free())

func add_log_message(message: String):
	print("[LOG]: ", message)
