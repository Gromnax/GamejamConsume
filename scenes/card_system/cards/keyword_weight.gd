extends Resource
class_name KeywordWeight

var label: String
var weight: int

func _init(new_label: String, new_weight: int):
	self.label = new_label
	self.weight = new_weight
