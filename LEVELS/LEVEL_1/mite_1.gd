extends Node2D

@export var offset = Vector2(0., 16.)
@export var duration = 6.0
var tween: Tween
@onready var animatedSprite = $mold_mite_1/AnimatedSprite2D
@onready var collisionShape = $mold_mite_1/CollisionShape2D
@onready var moldMite = $mold_mite_1

func start():
	animatedSprite.play("walk_forward")
	tween.play()
	collisionShape.disabled = false
	
func stop():
	collisionShape.disabled = true
	tween.pause()
	animatedSprite.play("idle")

func _ready():
	animatedSprite.play("walk_forward")
	start_tween()

func start_tween():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(moldMite, "position", offset, duration / 2)
	tween.tween_interval(2.0)
	tween.tween_property(moldMite, "position", Vector2.ZERO, duration / 2)
	tween.tween_interval(2.0)

func _on_player_mite_1_collide() -> void:
	stop()
	var timer = get_tree().create_timer(5.)
	await timer.timeout
	start()
