@tool
extends Button
class_name Card

@export var data : CardData :
	set(new_data):
		data = new_data

@export_tool_button("Refresh", "Callable") var refresh_action = refresh 

func refresh() -> void :
	if data and data.keyword:
		%CardLabel.text = data.keyword
	elif data:
		%CardLabel.text = "Empty keyword"
	else:
		%CardLabel.text = "Placeholder"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	pass # Replace with function body.
