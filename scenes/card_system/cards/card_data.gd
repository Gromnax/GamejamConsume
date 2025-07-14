extends Resource
class_name CardData

@export var keyword : String 
##Negative : Left, Zero : Neutral, Positive : Right
@export var politics_weight : float
var left_multiplier: float
var right_multiplier: float
	

func _init(label: String = "Empty keyword", weight: float = 0, new_left_multiplier: float = 1, new_right_multiplier: float = 1) -> void:
	self.keyword = label
	self.politics_weight = weight
	self.left_multiplier = new_left_multiplier
	self.right_multiplier = new_right_multiplier
