class_name Dialogue
extends Control

@onready var content := get_node("Content") as RichTextLabel
@onready var type_timer := get_node("TypeTyper") as Timer
@onready var pause_timer := get_node("PauseTimer") as Timer
@onready var _calc := get_node("PauseCalculator") as PauseCalculator

signal message_completed

func update_message(message: String) -> void:
	content.bbcode_text = _calc.extract_pauses_from_string(message)
	content.visible_characters = 0
	type_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	update_message("[color=green][wave]hello[/wave] from me inside Godot! This... is really cool[/color]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_type_typer_timeout() -> void:
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		type_timer.stop()
		message_completed.emit()

func _on_pause_calculator_pause_requested(duration: Variant) -> void:
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()

func _on_pause_timer_timeout() -> void:
	pause_timer.stop()
	type_timer.start()
