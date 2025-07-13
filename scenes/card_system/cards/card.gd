@tool
extends Button
class_name Card

@export var data : CardData :
	set(new_data):
		data = new_data

@export_tool_button("Refresh", "Callable") var refresh_action: Callable = refresh 
@export_tool_button("Randomize", "Callable") var random_action: Callable = randomize

@onready var randomize_button: Button = %RandomizeButton
@onready var card_label: Label = %CardLabel
@onready var card_weight: Label = %CardWeight

func refresh() -> void :
	if data and data.keyword:
		card_label.text = data.keyword
		card_weight.text = str(data.politics_weight)
	elif data:
		card_label.text = "Empty keyword"
		card_weight.text = str(0)
	else:
		card_label.text = "Placeholder"
		card_weight.text = str(0)
		
func randomize() -> void :
	var keyword_weight: KeywordWeight = KeywordManager.get_random_keyword()
	if keyword_weight == null:
		data = CardData.new()
		refresh()
	else:	
		data.keyword = keyword_weight.label
		data.politics_weight = keyword_weight.weight
		refresh()

func _init() -> void:
		data = CardData.new()
		
func _ready() -> void:
	refresh()		
	randomize_button.button_down.connect(randomize)

func _process(_delta: float) -> void:
	pass


func _on_gui_input(_event: InputEvent) -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	pass # Replace with function body.
