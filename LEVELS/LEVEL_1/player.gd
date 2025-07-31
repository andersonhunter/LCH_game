extends CharacterBody2D

var speed = Global.speed
var screen_size
var bat = preload("res://LEVELS/LEVEL_1/bat.tscn").instantiate()
signal mite_1_collide

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
	if Global.has_bat:
		var parent := get_parent()
		# Wait until parent is ready, then add bat as sibling
		parent.ready.connect(func():
			add_sibling(bat)
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
		$RayCast2D.rotation_degrees = rad_to_deg(input.angle()) + 90.
	if $RayCast2D.is_colliding():
		# Collision detection for ray
		var collider = $RayCast2D.get_collider()
		if collider.name == "mold_mite_1":
			# Maybe add a switch statement function for collisions?
			# match (collider.name) case "mold_mite_1": startConversation
			# Also need rotation of raycast
			mite_1_collide.emit()
	velocity = input * speed
	move_and_slide()
	if get_real_velocity() != Vector2.ZERO:
		Global.position_array.push_front(position)
		Global.position_array.pop_back()
	if bat:
		if get_real_velocity() != Vector2.ZERO && !bat.visible:
			bat.show()
		bat.position = Global.position_array[20]
