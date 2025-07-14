extends Control

@onready var news_container: HBoxContainer = %NewsContainer
@onready var cards_container_1: VBoxContainer = %CardsContainer
@onready var cards_container_2: VBoxContainer = %CardsContainer2
@onready var cards_container_3: VBoxContainer = %CardsContainer3
@onready var randomize_button: Button = %RandomizeButton

var selected_cards: Array[Card] = []

var left_counter: float = 50
var right_counter: float = 50

var current_right_counter: float = 0
var current_left_counter: float = 0

func _ready() -> void:
	
	KeywordManager.create_all_cards()
	
	for i in range(3):
		_add_random_card(cards_container_1)
	for j in range(3):	
		_add_random_card(cards_container_2)
	for k in range(3):
		_add_random_card(cards_container_3)
		
	SignalBus.card_selected.connect(_on_card_selected)	
	SignalBus.card_deselected.connect(_on_card_deselected)
	randomize_button.button_down.connect(_randomize)
	

func _add_random_card(cards_container: VBoxContainer) -> void:	
	var card: Card = KeywordManager.get_random_card()
	if card != null:
		cards_container.add_child(card)
		card.refresh()
		
func _on_card_selected(card: Card) -> void:
	if selected_cards.has(card) or selected_cards.size() == 3:
		SignalBus.selection_array_full.emit(selected_cards)
		return
		
	var weight: float = card.data.politics_weight	
	
	selected_cards.append(card)	
	if weight > 0:
		current_right_counter += weight
		current_left_counter -= weight
	elif weight < 0:
		current_left_counter += abs(weight)
		current_right_counter -= abs(weight)
	else:
		print(current_left_counter)
		print(current_right_counter)
		current_left_counter = current_left_counter * card.data.left_multiplier
		current_right_counter = current_right_counter * card.data.right_multiplier

	if OS.is_debug_build():
		print("Current left counter selected: %s" % current_left_counter)
		print("Current right counter selected: %s" % current_right_counter)

		
func _on_card_deselected(card: Card) -> void:
	if selected_cards.has(card):
		selected_cards.erase(card)
	
	var weight: float = card.data.politics_weight
		
	if weight > 0:
		current_right_counter -= weight
		current_left_counter += weight
	elif weight < 0:
		current_left_counter -= abs(weight)
		current_right_counter += abs(weight)
	else:
		current_left_counter = current_left_counter / card.data.left_multiplier
		current_right_counter = current_right_counter / card.data.right_multiplier
	if OS.is_debug_build():
		print("Current left counter deselected : %s" % current_left_counter)
		print("Current right counter deselected: %s" % current_right_counter)



func _randomize() -> void:
	KeywordManager.reset_used_cards()
	left_counter += current_left_counter
	current_left_counter = 0
	right_counter += current_right_counter
	current_right_counter = 0

	if OS.is_debug_build():
		print("Left counter: %s" % left_counter)
		print("Right counter : %s" % right_counter)
	selected_cards.clear()
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
