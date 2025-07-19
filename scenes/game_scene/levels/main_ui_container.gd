extends Control

@onready var news_container: HBoxContainer = %NewsContainer
@onready var cards_container_1: VBoxContainer = %CardsContainer
@onready var cards_container_2: VBoxContainer = %CardsContainer2
@onready var cards_container_3: VBoxContainer = %CardsContainer3

@onready var crowd_progress_bar: ProgressBar = %CrowdProgressBar
@onready var ceo_progress_bar: ProgressBar = %CEOProgressBar

@onready var exit_button: Button = %ExitButton

@onready var game_over_container: Control = %GameOverContainer
@onready var retry_button: Button = %RetryButton
@onready var exit_button_game_over: Button = %ExitButtonGameOver

@onready var event_text: RichTextLabel = %EventText

@onready var elon: Sprite2D = %Elon
@onready var people: Sprite2D = %People
var tween: Tween

const ELON_NORMAL = preload("res://assets/images/characters/melon_normal.png")
const PEOPLE_NORMAL = preload("res://assets/images/characters/people_normal.png")
const ELON_HUNGRY = preload("res://assets/images/characters/melon_angry.png")
const PEOPLE_HAPPY = preload("res://assets/images/characters/people_happy.png")
const ELON_HAPPY = preload("res://assets/images/characters/melon_happy.png")
const PEOPLE_ANGRY = preload("res://assets/images/characters/people_angry.png")
const MAIN_SCENE: PackedScene = preload("res://scenes/menu/main_menu.tscn")

var selected_cards: Array[Card] = []
var left_counter: float = 50
var right_counter: float = 50
var current_right_counter: float = 0
var current_left_counter: float = 0
var round_counter: int = 0
var current_event: Event = null

func _ready() -> void:
	var custom_cursor: Texture2D = preload("res://assets/images/cursor.png")
	Input.set_custom_mouse_cursor(custom_cursor)

	get_tree().paused = false
	KeywordManager.create_all_cards()

	for i in range(3): _add_random_card(cards_container_1)
	for j in range(3): _add_random_card(cards_container_2)
	for k in range(3): _add_random_card(cards_container_3)

	SignalBus.card_selected.connect(_on_card_selected)
	SignalBus.card_deselected.connect(_on_card_deselected)
	exit_button.button_down.connect(_on_exit_button_down)
	exit_button_game_over.button_down.connect(_on_exit_button_down)
	retry_button.button_down.connect(_on_retry_button)
	game_over_container.visible = false

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
		current_left_counter *= card.data.left_multiplier
		current_right_counter *= card.data.right_multiplier

	if selected_cards.size() == 3:
		_valid_cards()

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
		current_left_counter /= card.data.left_multiplier
		current_right_counter /= card.data.right_multiplier

func _valid_cards() -> void:
	
		# Déclenche effets visuels en fonction des points gagnés
	if current_left_counter > 0:
		_set_temp_elon_and_people(ELON_HUNGRY, PEOPLE_HAPPY)
	elif current_right_counter > 0:
		_set_temp_elon_and_people(ELON_HAPPY, PEOPLE_ANGRY)
	
	KeywordManager.reset_used_cards()
	crowd_progress_bar.value += current_left_counter
	ceo_progress_bar.value += current_right_counter
	current_left_counter = 0
	current_right_counter = 0
	selected_cards.clear()

	_remove_child_from_container(cards_container_1)
	_remove_child_from_container(cards_container_2)
	_remove_child_from_container(cards_container_3)

	if (ceo_progress_bar.value <= 0 or crowd_progress_bar.value <= 0) or (ceo_progress_bar.value >= 100 or crowd_progress_bar.value >= 100):
		game_over_container.visible = true
		get_tree().paused = true
		game_over_container.process_mode = PROCESS_MODE_ALWAYS

	round_counter += 1
	_enable_event()

	for i in range(3): _add_random_card(cards_container_1)
	for j in range(3): _add_random_card(cards_container_2)
	for k in range(3): _add_random_card(cards_container_3)

func _remove_child_from_container(container: VBoxContainer) -> void:
	for child in container.get_children():
		if child is Card:
			container.remove_child(child)
			child.queue_free()

func _on_exit_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_retry_button() -> void:
	KeywordManager.reset_used_cards()
	get_tree().reload_current_scene()

func _enable_event() -> void:
	if left_counter > 75 or right_counter < 25:
		EventManager.get_major_event_with_desc("Left Event")
	elif right_counter > 75 or left_counter < 25:
		EventManager.get_major_event_with_desc("Right Event")

	if round_counter % 3 == 0:
		current_event = EventManager.get_random_minor_event()
		event_text.text = "EVENT " + str(current_event.polical_type)
		event_text.visible = true
	else:
		current_event = null
		event_text.visible = false

func _set_temp_elon_and_people(elon_texture: Texture2D, people_texture: Texture2D) -> void:
	elon.texture = elon_texture
	people.texture = people_texture

	get_tree().create_tween().tween_callback(Callable(self, "_reset_elon_and_people")).set_delay(1.0)

func _reset_elon_and_people() -> void:
	elon.texture = ELON_NORMAL
	people.texture = PEOPLE_NORMAL
