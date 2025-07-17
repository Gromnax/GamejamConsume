extends Control

@onready var news_container: HBoxContainer = %NewsContainer
@onready var cards_container_1: VBoxContainer = %CardsContainer
@onready var cards_container_2: VBoxContainer = %CardsContainer2
@onready var cards_container_3: VBoxContainer = %CardsContainer3
#@onready var randomize_button: Button = %RandomizeButton

@onready var crowd_progress_bar: ProgressBar = %CrowdProgressBar
@onready var ceo_progress_bar: ProgressBar = %CEOProgressBar

@onready var menu_button: Button = %MenuButton
@onready var menu_panel: Panel = %MenuPanel
@onready var exit_button: Button = %ExitButton

@onready var game_over_container: Control = %GameOverContainer
@onready var retry_button: Button = %RetryButton
@onready var exit_button_game_over: Button = %ExitButtonGameOver

@onready var event_text: RichTextLabel = %EventText

var selected_cards: Array[Card] = []

var left_counter: float = 50
var right_counter: float = 50

var current_right_counter: float = 0
var current_left_counter: float = 0

var round_counter: int = 0
var current_event: Event = null

func _ready() -> void:

	get_tree().paused = false
	KeywordManager.create_all_cards()
	
	for i in range(3):
		_add_random_card(cards_container_1)
	for j in range(3):	
		_add_random_card(cards_container_2)
	for k in range(3):
		_add_random_card(cards_container_3)
		
	SignalBus.card_selected.connect(_on_card_selected)	
	SignalBus.card_deselected.connect(_on_card_deselected)
	menu_button.button_down.connect(_on_menu_button_down)
	exit_button.button_down.connect(_on_exit_button_down)
	menu_panel.visible = false
	game_over_container.visible = false
	exit_button_game_over.button_down.connect(_on_exit_button_down)
	retry_button.button_down.connect(_on_retry_button)
	

func _add_random_card(cards_container: VBoxContainer) -> void:	
	var card: Card = KeywordManager.get_random_card()
	if card != null:
		cards_container.add_child(card)
		card.refresh()
		
	if current_event and card.data.politics_weight == 0:
		if current_event.polical_type == "left":
			card.data.left_multiplier = current_event.multiplier
			card.data.right_multiplier = 1.0
		elif current_event.polical_type == "right":
			card.data.right_multiplier = current_event.multiplier
			card.data.left_multiplier = 1.0
		
		
		
func _on_card_selected(card: Card) -> void:
	if selected_cards.has(card):
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
		current_left_counter = current_left_counter * card.data.left_multiplier
		current_right_counter = current_right_counter * card.data.right_multiplier

	if selected_cards.size() == 3:
		_valid_cards()
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

func _valid_cards() -> void:
	KeywordManager.reset_used_cards()
	crowd_progress_bar.value += current_left_counter
	current_left_counter = 0
	ceo_progress_bar.value += current_right_counter
	current_right_counter = 0

	if OS.is_debug_build():
		print("Left counter: %s" % left_counter)
		print("Right counter : %s" % right_counter)
	selected_cards.clear()
	_remove_child_from_container(cards_container_1)
	_remove_child_from_container(cards_container_2)
	_remove_child_from_container(cards_container_3)
	
	if (ceo_progress_bar.value <= 0 or crowd_progress_bar.value <= 0) or (ceo_progress_bar.value >= 100 or crowd_progress_bar.value >= 100):
		game_over_container.visible = true
		get_tree().paused = true
		game_over_container.process_mode = PROCESS_MODE_ALWAYS
		
		if OS.is_debug_build():
			print("Game Over!")

	round_counter += 1
	_enable_event()
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

func _on_menu_button_down() -> void:
	get_tree().paused = !get_tree().paused
	%MenuContainer.process_mode = PROCESS_MODE_ALWAYS
	menu_panel.visible = !menu_panel.visible

func _on_exit_button_down() -> void:
	var main_scene: PackedScene = preload("res://scenes/menus/main_menu/main_menu.tscn")
	get_tree().change_scene_to_packed(main_scene)
	
func _on_retry_button() -> void:	
	get_tree().reload_current_scene()

func _enable_event() -> void:
	if left_counter > 75:
		EventManager.get_major_event_with_desc("Left Event")
	elif right_counter > 75:	
		EventManager.get_major_event_with_desc("Right Event")
	elif left_counter < 25:
		EventManager.get_major_event_with_desc("Right Event")
	elif right_counter < 25:
		EventManager.get_major_event_with_desc("Left Event")
	
	if round_counter % 3 == 0:
		current_event = EventManager.get_random_minor_event()
		event_text.text = "EVENT " + str(current_event.polical_type)
		event_text.visible = true
	else:
		current_event = null
		event_text.visible = false
		