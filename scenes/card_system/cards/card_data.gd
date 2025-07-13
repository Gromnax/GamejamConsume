extends Resource
class_name CardData

@export var keyword : String 
##Negative : Left, Zero : Neutral, Positive : Right
@export var politics_weight : int

func _init() -> void:
	var keyword_weight : KeywordWeight = KeywordManager.get_random_keyword()
	if keyword_weight != null:
		keyword = keyword_weight.label
		politics_weight = keyword_weight.weight
	
