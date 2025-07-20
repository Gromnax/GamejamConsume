@tool
extends Control

@export var has_speaker : bool = false :
	set(new_value):
		assert(is_node_ready())
		has_speaker = new_value
		%SpeakerNameContainer.visible = has_speaker
@export var speaker : String :
	set(new_value):
		%SpeakerName.text = new_value
		speaker = new_value

@export var dialogue : DialogueContainer
@export var dialogue_text : String :
	set(new_value):
		dialogue_text = new_value
		dialogue.update_message(dialogue_text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
