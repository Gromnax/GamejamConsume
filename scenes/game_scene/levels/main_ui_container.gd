extends Control

@onready var news_container: HBoxContainer = %NewsContainer
@onready var cards_container_1: VBoxContainer = %CardsContainer
@onready var cards_container_2: VBoxContainer = %CardsContainer2
@onready var cards_container_3: VBoxContainer = %CardsContainer3


func _ready() -> void:
	
	KeywordManager.create_all_cards()
	
	for i in range(3):
		_add_random_card(cards_container_1)
	for j in range(3):	
		_add_random_card(cards_container_2)
	for k in range(3):
		_add_random_card(cards_container_3)
		
func _add_random_card(cards_container: VBoxContainer) -> void:	
	var card: Card = KeywordManager.get_random_card()
	if card != null:
		cards_container.add_child(card)
		card.refresh()
