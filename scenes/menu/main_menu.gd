extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var credits_button: Button = %CreditsButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	new_game_button.button_down.connect(_on_new_game_button_down)
	credits_button.button_down.connect(_on_credits_button_down)
	exit_button.button_down.connect(_on_exit_button_down)
	
func _on_new_game_button_down() -> void:
	$clickAudio.play()
	KeywordManager.reset_used_cards()
	get_tree().change_scene_to_file("res://scenes/game_scene/levels/game_scene_UI.tscn")

func _on_credits_button_down() -> void:	
	$clickAudio.play()
	pass
	
func _on_exit_button_down() -> void:	
	get_tree().quit()
