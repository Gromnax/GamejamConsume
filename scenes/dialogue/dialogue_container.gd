extends PanelContainer
class_name DialogueContainer

@export var content : RichTextLabel
@onready var type_timer : Timer = $TypeTimer
@onready var pause_timer : Timer = $PauseTimer

@export var content_text : String :
	set(new_value):
		content_text = new_value
		update_message(new_value)

signal message_done_updating

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_message("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_message(message : String) -> void:
	if !is_node_ready():
		pass
	content.text = message
	content.visible_characters = 0
	type_timer.start()
	
func _on_type_timer_timeout() -> void:
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		type_timer.stop()
		pause_timer.start()


func _on_pause_timer_timeout() -> void:
	message_done_updating.emit()
	pause_timer.stop()
