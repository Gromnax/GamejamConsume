extends Control

@export var new_game_button: Button
@export var credits_button: Button
@export var exit_button: Button

var credits : bool = false :
	set(new_val):
		credits = new_val
		%Panel.visible = !credits
		%Credits.visible = credits

func _ready() -> void:
	credits = false
	if new_game_button:
		new_game_button.button_down.connect(_on_new_game_button_down)
	if credits_button:
		credits_button.button_down.connect(_on_credits_button_down)
	if exit_button:
		exit_button.button_down.connect(_on_exit_button_down)

func _on_new_game_button_down() -> void:
	$clickAudio.play()
	KeywordManager.reset_used_cards()
	get_tree().change_scene_to_file("res://scenes/intro_cinematic/intro.tscn")

func _on_credits_button_down() -> void:	
	$clickAudio.play()
	credits = true
	
func _on_exit_button_down() -> void:	
	queue_free()

func _on_back_button_pressed() -> void:
	$clickAudio.play()
	credits = false
