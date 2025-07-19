extends Node
class_name CardManager

var right: KeywordWeight = KeywordWeight.new("Right", 1)
var right_shareholding: KeywordWeight = KeywordWeight.new("Shareholding", 2)
var right_private: KeywordWeight = KeywordWeight.new("Private", 3)
var right_meritocracy: KeywordWeight = KeywordWeight.new("Meritocracy", 4)
var right_business: KeywordWeight = KeywordWeight.new("Business", 5)
var right_migration: KeywordWeight = KeywordWeight.new("Migration", 6)
var right_elite: KeywordWeight = KeywordWeight.new("Elite", 7)
var right_tradition: KeywordWeight = KeywordWeight.new("Tradition", 8)
var right_security: KeywordWeight = KeywordWeight.new("Security", 9)
var right_identity: KeywordWeight = KeywordWeight.new("Identity", 10)

var neutral_democraty: KeywordWeight = KeywordWeight.new("Democraty", 0, 2, 3)
var neutral_budget: KeywordWeight = KeywordWeight.new("Budget", 0, 0.5, 3)
var neutral_justice: KeywordWeight = KeywordWeight.new("Justice", 0, 2, 0.5)
var neutral_capitalism: KeywordWeight = KeywordWeight.new("Capitalism", 0, 0.5, 3)
var neutral_invasion: KeywordWeight = KeywordWeight.new("Invasion", 0, 2, 0.5)
var neutral_state: KeywordWeight = KeywordWeight.new("State", 0, 0.5, 3)
var neutral_layoff: KeywordWeight = KeywordWeight.new("Layoff", 0, 2, 0.5)
var neutral_reform: KeywordWeight = KeywordWeight.new("Reform", 0, 0.5, 3)
var neutral_election: KeywordWeight = KeywordWeight.new("Election", 0, 2, 0.5)
var neutral_law: KeywordWeight = KeywordWeight.new("Law", 0, 0.5, 3)

var left: KeywordWeight = KeywordWeight.new("Left", -1)
var left_ecology: KeywordWeight = KeywordWeight.new("Ecology", -2)
var left_social: KeywordWeight = KeywordWeight.new("Social", -3)
var left_public: KeywordWeight = KeywordWeight.new("Public", -4)
var left_people: KeywordWeight = KeywordWeight.new("People", -5)
var left_socialism: KeywordWeight = KeywordWeight.new("Socialism", -6)
var left_solidarity: KeywordWeight = KeywordWeight.new("Solidarity", -7)
var left_progressivism: KeywordWeight = KeywordWeight.new("Progressivism", -8)
var left_inclusiveness: KeywordWeight = KeywordWeight.new("Inclusiveness", -9)
var left_strike: KeywordWeight = KeywordWeight.new("Strike", -10)

var keywords_array: Array[KeywordWeight] = [
	right, right_shareholding, right_private, right_meritocracy, right_business,
	right_migration, right_elite, right_tradition, right_security, right_identity,
	neutral_democraty, neutral_budget, neutral_justice, neutral_capitalism,
	neutral_invasion, neutral_state, neutral_layoff, neutral_reform,
	neutral_election, neutral_law,
	left, left_ecology, left_social, left_public, left_people,
	left_socialism, left_solidarity, left_progressivism,
	left_inclusiveness, left_strike
]

var cards: Array[Card] = []
var used_cards: Array[Card] = []

func get_random_keyword() -> KeywordWeight: 
	if keywords_array.size() == 0:
		return null
	var random_index: int = randi() % keywords_array.size()
	var keyword: KeywordWeight = keywords_array[random_index]
	keywords_array.erase(keyword)
	return keyword


func create_all_cards() -> void:
	var card_scene: PackedScene = preload("res://scenes/card_system/cards/card.tscn")
	for keyword_weight in keywords_array:
		var card: Card = card_scene.instantiate()
		var card_data : CardData = CardData.new(keyword_weight.label, keyword_weight.weight, keyword_weight.left_multiplier, keyword_weight.right_multiplier)
		card.data = card_data
		keywords_array.erase(keyword_weight)
		cards.append(card)


func get_random_card() -> Card:	
	if cards.size() == 0:
		return null
		
	var random_index: int = randi() % cards.size()
	var card: Card = cards[random_index].duplicate()
	for used_card in used_cards:
		if used_card.data.keyword == card.data.keyword:
			return get_random_card()
			
	used_cards.append(card)
	return card
	
func reset_used_cards() -> void:	
	used_cards.clear()
