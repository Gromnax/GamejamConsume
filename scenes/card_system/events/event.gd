extends Node
class_name Event



var description: String
# Major or Minor
var type: String
var polical_type: String
var multiplier: float

func _init(new_description: String, new_type: String, new_multiplier: float, new_polical_type: String) -> void:
	self.description = new_description 
	self.type = new_type
	self.multiplier = new_multiplier
	self.polical_type = new_polical_type