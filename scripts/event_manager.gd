extends Node

var event_right: Event = Event.new("Right Event", "minor", 4.0, "right")
var event_left: Event = Event.new("Left Event", "minor", 4.0, "left")

var event_left_major: Event = Event.new("Left Event", "major", 10.0, "left")
var event_right_major: Event = Event.new("Right Event", "major", 10.0, "right")

var minor_event_array: Array[Event] = [event_right, event_left]
var major_event_array: Array[Event] = [event_left_major, event_right_major]

func _ready():
	var custom_cursor: Texture2D = preload("res://assets/images/cursor.png")
	Input.set_custom_mouse_cursor(custom_cursor)

func choose_event() -> Event:
	return null
	
func get_random_minor_event() -> Event:	
	if minor_event_array.size() == 0:
		return null
	var random_index: int = randi() % minor_event_array.size()
	return minor_event_array[random_index]


func get_major_event_with_desc(description: String) -> Event:
	for event in major_event_array:
		if event.description == description:
			major_event_array.erase(event)
			return event
	return null
