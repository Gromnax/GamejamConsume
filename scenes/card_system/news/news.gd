extends PanelContainer

@onready var selected_card : Card
@onready var cards : Array[Card] = fill_card_array()
# Called when the node enters the scene tree for the first time.

func fill_card_array() -> Array[Card]:
	var result : Array[Card] = []
	for child in %CardContainer.get_children():
		if child is Card:
			result.append(child)
	return result


func _ready() -> void:
	SignalBus.card_selected.connect(on_card_selected)
	pass # Replace with function body.


func on_card_selected(new_selected_card : Card) -> void:
	var card_index : int = cards.find(new_selected_card)
	#Si on trouve pas la carte sélectionnée, ça ne nous concerne pas
	if card_index == -1:
		return
	selected_card = cards[card_index]
	for card_child in cards:
		if not card_child == new_selected_card:
			card_child.force_deselect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
