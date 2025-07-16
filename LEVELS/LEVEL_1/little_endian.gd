extends Node

var house_1 = "res://LEVELS/LEVEL_1/inside_house_1.tscn"
var house_2 = "res://LEVELS/LEVEL_1/inside_house_2.tscn"
var house_3 = "res://LEVELS/LEVEL_1/inside_house_3.tscn"
var house_4 = "res://LEVELS/LEVEL_1/inside_house_4.tscn"

func set_leds() -> void:
	# Set the LED frames and begin playing
	$LED_1.set_frame_and_progress(6, 0.0)
	$LED_2.set_frame_and_progress(5, 0.0)
	$LED_3.set_frame_and_progress(4, 0.0)
	$LED_4.set_frame_and_progress(3, 0.0)
	$LED_1.play()
	$LED_2.play()
	$LED_3.play()
	$LED_4.play()

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
	set_leds()

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
