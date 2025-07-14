extends Resource
class_name CardData

@export var keyword : String 
##Negative : Left, Zero : Neutral, Positive : Right
@export var politics_weight : int
	

func _init(label: String = "Empty keyword", weight: int = 0) -> void:
	self.keyword = label
	self.politics_weight = weight
