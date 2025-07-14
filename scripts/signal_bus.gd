extends Node

@warning_ignore("unused_signal")
signal card_selected(card: Card, weight: int)
@warning_ignore("unused_signal")
signal card_deselected(card: Card, weight: int)
@warning_ignore("unused_signal")
signal selection_array_full(selected_cards: Array[Card])