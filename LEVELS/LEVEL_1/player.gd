extends CharacterBody2D

@export var speed = 400 # Speed in pixels/sec
var screen_size

func get_input():
	var input_dir = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
		)
	velocity = input_dir * speed
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready():
	screen_size = get_viewport_rect().size
