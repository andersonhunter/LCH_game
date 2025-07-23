extends CharacterBody2D

var speed = Global.speed
var screen_size
var bat = preload("res://LEVELS/LEVEL_1/bat.tscn").instantiate()

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
	var input = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
		)
	velocity = input * speed
	move_and_slide()
	if get_real_velocity() != Vector2.ZERO:
		Global.position_array.push_front(position)
		Global.position_array.pop_back()
	if bat:
		if get_real_velocity() != Vector2.ZERO && !bat.visible:
			bat.show()
		bat.position = Global.position_array[20]
