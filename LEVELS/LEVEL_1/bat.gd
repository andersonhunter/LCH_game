extends CharacterBody2D

func _ready() -> void:
	hide()
	
func _process(delta: float) -> void:
	# Update follower position
	position = Global.position_array[20]
