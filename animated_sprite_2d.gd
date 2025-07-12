extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_down"):
		play("down")
	elif Input.is_action_pressed("move_left"):
		play("left")
	elif Input.is_action_pressed("move_right"):
		play("right")
	elif Input.is_action_pressed("move_up"):
		play("forward")
	else:
		play("idle")
