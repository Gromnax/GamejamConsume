extends Control

@export var back_button: Button :
	set(new_button):
		back_button = new_button
		back_button.button_down.connect(_on_back_button_down)

func _ready() -> void:
	pass

func _on_back_button_down() -> void:
	$clickAudio.play()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
