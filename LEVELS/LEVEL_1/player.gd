extends CharacterBody2D

var speed = Global.speed
var screen_size
var bat = preload("res://LEVELS/LEVEL_1/bat.tscn").instantiate()
signal mite_1_collide
signal startDialogue(collider: CharacterBody2D)
signal enterSwamp
@onready var rayCast = $RayCast2D

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready():
	screen_size = get_viewport_rect().size
	# Prepare character position array
	Global.position_array.resize(100)
	Global.position_array.fill(position)
	# If character has bat companion, add them
	var parent := get_parent()
	# Wait until parent is ready, then add bat as sibling
	parent.ready.connect(func():
		parent.add_child(bat)
	)
	bat.hide()
	bat.position = position

func _process(delta: float) -> void:
	var input = Vector2.ZERO
	input = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
		)
	# Perform raycasting logic
	if input != Vector2.ZERO:
		# Moving, so rotate raycast
		rayCast.rotation_degrees = rad_to_deg(input.angle()) + 90.
	if rayCast.is_colliding():
		# Collision detection for ray
		var collider = rayCast.get_collider()
		match collider.name:
			"mold_mite_1":
				$enterPrompt.show()
				if Input.is_action_pressed("enter"):
					startDialogue.emit(collider)
			"BatSolo":
				$enterPrompt.show()
				if Input.is_action_pressed("enter"):
					startDialogue.emit(collider)
			"enterSwamp":
				if Global.has_bat:
					$enterNewAreaPrompt.show()
					if Input.is_action_pressed("enter"):
						enterSwamp.emit()
	if not rayCast.is_colliding():
		$enterPrompt.hide()
	velocity = input * speed
	move_and_slide()
	if get_real_velocity() != Vector2.ZERO:
		Global.position_array.push_front(position)
		Global.position_array.pop_back()
	if Global.has_bat:
		if get_real_velocity() != Vector2.ZERO && !bat.visible:
			bat.show()
		bat.position = Global.position_array[20]
