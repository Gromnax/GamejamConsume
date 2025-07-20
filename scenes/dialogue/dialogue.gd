#@tool
extends Control
class_name Dialogue


@export var dialogue_container : DialogueContainer
var dialogue_text : String :
	set(new_value):
		dialogue_text = new_value
		dialogue_container.update_message(dialogue_text)

@export var dialogue_data : DialogueData :
	set(new_value):
		dialogue_data = new_value

#@export_tool_button("Update Dialogue") var update_dialogue : Callable = update_d 


var current_dialogue_number : int :
	set(new_value):
		previous_dialogue_number = current_dialogue_number
		current_dialogue_number = new_value
		if new_value < dialogue_data.dialogues.size():
			current_dialogue = dialogue_data.dialogues[current_dialogue_number]
var previous_dialogue_number : int = 0
@export var speakernamecontainer : PanelContainer
@export var speakername : RichTextLabel
@export var has_speaker : bool = false :
	set(new_value):
		has_speaker = new_value
		if speakernamecontainer:
			speakernamecontainer.visible = has_speaker
@export var speaker : String :
	set(new_value):
		if speakername:
			speakername.text = new_value
		speaker = new_value
@export var current_dialogue : DialogueLine :
	set(new_value):
		if new_value:
			has_speaker = new_value.has_speaker
			speaker = new_value.speaker_name
			dialogue_text = new_value.dialogue_content
			dialogue_container.update_message(dialogue_text)


func update_d() -> void:
	current_dialogue_number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_container_message_done_updating() -> void:
	if current_dialogue_number < dialogue_data.dialogues.size()-1:
		if current_dialogue_number != previous_dialogue_number:
			current_dialogue = dialogue_data.dialogues[current_dialogue_number]
			print(current_dialogue_number)
		current_dialogue_number += 1
