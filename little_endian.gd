extends Node

var house_1 = "res://inside_house.tscn"

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enter_pink_house_body_entered(body: Node2D) -> void:
	# Player is entering pink house
	if body == $Player:
		# Save location for later
		Global.player_location = $Player.position
		Global.goto_scene(house_1)
