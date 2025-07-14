extends Resource
class_name KeywordWeight

var label: String
var weight: int
var multiplier: int

func _init(new_label: String, new_weight: int, new_multiplier: int = 1) -> void:
	self.label = new_label
	self.weight = new_weight
	self.multiplier = new_multiplier
