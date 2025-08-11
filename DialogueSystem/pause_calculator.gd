class_name PauseCalculator
extends Node

var _pauses := []
const PAUSE_PATTERN := "({p=\\d([.]\\d+)?[}])"
var _pause_regex := RegEx.new()
signal pause_requested(duration)

func _adjust_position(pos: int, source_string: String) -> int:
	var _custom_tag_regex := RegEx.new()
	_custom_tag_regex.compile("({(.*?)})")
	var _new_pos := pos
	var _left_of_pos := source_string.left(pos)
	var _all_prev_tags := _custom_tag_regex.search_all(_left_of_pos)
	for _tag_result in _all_prev_tags:
		_new_pos -= _tag_result.get_string().length()
	
	var _bbcode_i_regex := RegEx.new()
	var _bbcode_e_regex := RegEx.new()
	
	_bbcode_i_regex.compile("\\[(?!\\/)(.*?)\\]")
	_bbcode_e_regex.compile("\\[\\/(.*?)\\]")
	
	var _all_prev_start_bbcodes := _bbcode_i_regex.search_all(_left_of_pos)
	for _tag_result in _all_prev_start_bbcodes:
		_new_pos -= _tag_result.get_string().length()
	
	var _all_prev_end_bbcodes := _bbcode_e_regex.search_all(_left_of_pos)
	for _tag_result in _all_prev_end_bbcodes:
		_new_pos -= _tag_result.get_string().length()
	
	return _new_pos

func check_at_position(pos):
	for _pause in _pauses:
		if _pause.pause_pos == pos:
			emit_signal("pause_requested", _pause.duration)

func extract_pauses_from_string(source_string: String) -> String:
	_pauses = []
	_find_pauses(source_string)
	return _extract_tags(source_string)

func _find_pauses(source_string: String) -> void:
	var _found_pauses := _pause_regex.search_all(source_string)
	for _result in _found_pauses:
		var _tag_string := _result.get_string() as String
		var _tag_position := _adjust_position(
			_result.get_start(),
			source_string
		)
		var _pause = Pause.new(_tag_position, _tag_string)
		_pauses.append(_pause)
	
func _extract_tags(source_string: String) -> String:
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*)})")
	return _custom_regex.sub(source_string, "", true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pause_regex.compile(PAUSE_PATTERN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
