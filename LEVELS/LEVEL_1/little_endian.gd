extends Node

var house_1 = "res://LEVELS/LEVEL_1/inside_house_1.tscn"
var house_2 = "res://LEVELS/LEVEL_1/inside_house_2.tscn"
var house_3 = "res://LEVELS/LEVEL_1/inside_house_3.tscn"
var house_4 = "res://LEVELS/LEVEL_1/inside_house_4.tscn"

func set_leds(parent_node: Node2D) -> void:
	# Set the LED frames and begin playing
	var frame: int = 3
	for node in range(parent_node.get_child_count()):
		print(frame)
		parent_node.get_child(node).set_frame_and_progress(frame, 0.0)
		parent_node.get_child(node).play()
		if frame > 0:
			frame -= 1
		else:
			frame = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set player location
	# If player is returning to scene, set location as original location
	# Else set as start
	if Global.player_location != null:
		Global.player_location[1] += 2
		$Player.start(Global.player_location)
	else:
		$Player.start($StartPosition.position)
	set_leds($LED_SET_1)
	set_leds($LED_SET_2)
	set_leds($LED_SET_3)
	set_leds($LED_SET_4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enter_pink_house_body_entered(body: Node2D) -> void:
	# Player is entering pink house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		Global.goto_scene(house_1)

func _on_enter_purple_house_body_entered(body: Node2D) -> void:
	# Player is entering the purple house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		Global.goto_scene(house_2)

func _on_enter_blue_house_body_entered(body: Node2D) -> void:
	# Player is entering the blue house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		Global.goto_scene(house_3)

func _on_enter_brown_house_body_entered(body: Node2D) -> void:
	# Player is entering the brown house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		Global.goto_scene(house_4)
