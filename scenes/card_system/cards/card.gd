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
@onready var card_weight: Label = %WeightLabel

@onready var left_multiplier_label: Label = %LeftMultiplierLabel
@onready var right_multiplier_label: Label = %RightMultiplierLabel

var tween : Tween

var selected : bool = false :
	set(new_value):
		selected = new_value


func refresh() -> void :
	if data and data.keyword:
		text = data.keyword
		card_weight.text = str(data.politics_weight)
		if not Engine.is_editor_hint():
			left_multiplier_label.text = str(data.left_multiplier)
			right_multiplier_label.text = str(data.right_multiplier)
	elif data:
		card_label.text = "Empty keyword"
		card_weight.text = str(0)
		if not Engine.is_editor_hint():
			left_multiplier_label.text = str(data.left_multiplier)
			right_multiplier_label.text = str(data.right_multiplier)
	else:
		card_label.text = "Placeholder"
		card_weight.text = str(0)
		if not Engine.is_editor_hint():
			left_multiplier_label.text = str(data.left_multiplier)
			right_multiplier_label.text = str(data.right_multiplier)
			
func _init() -> void:
		data = CardData.new("Empty keyword", 0)
		
func _ready() -> void:
	
	toggle_mode = true

	
	refresh()
	if not Engine.is_editor_hint():
		SignalBus.selection_array_full.connect(_on_selection_array_full)
	if OS.is_debug_build():
		card_weight.visible = true
	randomize_button.button_down.connect(randomize)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
func _on_pressed() -> void:
	selected = !selected
	notify()

func force_deselect() -> void:
	selected = false
	notify()

func notify() -> void:
	if selected:
		SignalBus.card_selected.emit(self)
		
	if !selected:
		SignalBus.card_deselected.emit(self)

func _on_selection_array_full(selected_cards: Array[Card]) -> void: 
	if selected and !selected_cards.has(self):
		selected = false
		%SelectedMarker.visible = false

func _on_mouse_entered() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		
