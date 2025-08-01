extends Node

var house_1 = "res://LEVELS/LEVEL_1/inside_house_1.tscn"
var house_2 = "res://LEVELS/LEVEL_1/inside_house_2.tscn"
var house_3 = "res://LEVELS/LEVEL_1/inside_house_3.tscn"
var house_4 = "res://LEVELS/LEVEL_1/inside_house_4.tscn"
var bat_path = "res://LEVELS/LEVEL_1/bat.tscn"
var frameCount = 0

var speed = Global.speed

func set_leds(parent_node: Node2D) -> void:
	# Set the LED frames and begin playing
	var frame: int = 3
	for node in range(parent_node.get_child_count()):
		parent_node.get_child(node).set_frame_and_progress(frame, 0.0)
		parent_node.get_child(node).play()
		if frame > 0:
			frame -= 1
		else:
			frame = 3

func transition() -> void:
	# Play transition animation
	$Player.speed = 0
	$SceneTransitionRect.get_child(0).play("fade")
	$bgm.stop()
	await get_tree().create_timer(0.5).timeout

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
	# Start playing LED animations
	set_leds($LED_SET_1)
	set_leds($LED_SET_2)
	set_leds($LED_SET_3)
	set_leds($LED_SET_4)
	set_leds($LED_SET_5)
	set_leds($LED_SET_6)
	set_leds($LED_SET_7)
	set_leds($LED_SET_8)
	# Set up bgm
	$bgm.volume_db = Global.music_volume
	$bgm.play(Global.music_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enter_purple_house_body_entered(body: Node2D) -> void:
	# Player is entering the purple house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		await transition()
		Global.goto_scene(house_2)

func _on_enter_blue_house_body_entered(body: Node2D) -> void:
	# Player is entering the blue house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		await transition()
		Global.goto_scene(house_3)

func _on_enter_brown_house_body_entered(body: Node2D) -> void:
	# Player is entering the brown house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		await transition()
		Global.goto_scene(house_4)

func _on_enter_pink_house_body_entered(body: Node2D) -> void:
		# Player is entering pink house
	if body == $Player:
		## Save location for later
		Global.player_location = $Player.position
		Global.music_pos = $bgm.get_playback_position()
		await transition()
		Global.goto_scene(house_1)
