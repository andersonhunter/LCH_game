extends CharacterBody2D

var speed = Global.speed
var screen_size
var bat = preload("res://LEVELS/LEVEL_1/bat.tscn").instantiate()
var darkOverworld = preload("res://LEVELS/LEVEL_1/dark_overworld.tscn").instantiate()
signal mite_1_collide
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
	if Global.has_bat and Global.isDark:
		var parent := get_parent()
		# Wait until parent is ready, then add bat as sibling
		parent.ready.connect(func():
			parent.add_child(bat)
			parent.add_child(darkOverworld)
		)
		bat.hide()
		bat.position = position
	elif Global.has_bat:
		var parent := get_parent()
		# Wait until parent is ready, then add bat as sibling
		parent.ready.connect(func():
			parent.add_child(bat)
			parent.add_child(darkOverworld)
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
		if collider.name == "mold_mite_1":
			# Maybe add a switch statement function for collisions?
			# match (collider.name) case "mold_mite_1": startConversation
			# Also need rotation of raycast
			mite_1_collide.emit()
	if get_last_slide_collision():
		match get_last_slide_collision().get_collider().name:
			"mold_mite_1":
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
