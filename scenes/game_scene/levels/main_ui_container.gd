extends Control

@onready var news_container: HBoxContainer = %NewsContainer
@onready var cards_container_1: VBoxContainer = %CardsContainer
@onready var cards_container_2: VBoxContainer = %CardsContainer2
@onready var cards_container_3: VBoxContainer = %CardsContainer3
@onready var randomize_button: Button = %RandomizeButton

var left_counter: int = 50
var right_counter: int = 50

func _ready() -> void:
	
	KeywordManager.create_all_cards()
	
	for i in range(3):
		_add_random_card(cards_container_1)
	for j in range(3):	
		_add_random_card(cards_container_2)
	for k in range(3):
		_add_random_card(cards_container_3)
		
	SignalBus.card_selected.connect(_on_card_selected)	
	randomize_button.button_down.connect(_randomize)
	

func _add_random_card(cards_container: VBoxContainer) -> void:	
	var card: Card = KeywordManager.get_random_card()
	if card != null:
		cards_container.add_child(card)
		card.refresh()
		
func _on_card_selected(weight: int) -> void:
	if weight > 0:
		right_counter += weight
		left_counter -= weight
	elif weight < 0:	
		left_counter += abs(weight)
		right_counter -= abs(weight)
	else:
		return
	
	if OS.is_debug_build():
		print("Left counter: %s" % left_counter)
		print("Right counter : %s" % right_counter)
		
func _randomize() -> void:
	KeywordManager.reset_used_cards()
	_remove_child_from_container(cards_container_1)
	_remove_child_from_container(cards_container_2)
	_remove_child_from_container(cards_container_3)

	for i in range(3):
		_add_random_card(cards_container_1)
	for j in range(3):
		_add_random_card(cards_container_2)
	for k in range(3):
		_add_random_card(cards_container_3)
		
	
func _remove_child_from_container(container: VBoxContainer) -> void:
	for child in container.get_children():
		if child is Card:
			container.remove_child(child)
			child.queue_free()
