extends Node

var event_right: Event = Event.new("Right Event", "minor", 4.0, "right")
var event_left: Event = Event.new("Left Event", "minor", 4.0, "left")

var minor_event_array: Array[Event] = [event_right, event_left]
var major_event_array: Array[Event] = [event_left]

func choose_event() -> Event:
	return null
	
func get_random_minor_event() -> Event:	
	if minor_event_array.size() == 0:
		return null
	var random_index: int = randi() % minor_event_array.size()
	return minor_event_array[random_index]

func get_random_major_event() -> Event:
	if minor_event_array.size() == 0:
		return null
	var random_index: int = randi() % minor_event_array.size()
	return major_event_array[random_index]	