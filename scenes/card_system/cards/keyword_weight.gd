extends Resource
class_name KeywordWeight

var label: String
var weight: int
var left_multiplier: float
var right_multiplier: float

func _init(new_label: String, new_weight: int, new_left_multiplier: float = 1, new_right_multiplier: float = 1) -> void:
	self.label = new_label
	self.weight = new_weight
	self.left_multiplier = new_left_multiplier
	self.right_multiplier = new_right_multiplier
