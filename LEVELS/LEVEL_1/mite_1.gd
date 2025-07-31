extends Node2D

@export var offset = Vector2(0., 16.)
@export var duration = 6.0
var tween: Tween

func start():
	$mold_mite_1/AnimatedSprite2D.play("walk_forward")
	tween.play()
	$mold_mite_1/CollisionShape2D.disabled = false
	
func stop():
	$mold_mite_1/CollisionShape2D.disabled = true
	tween.pause()
	$mold_mite_1/AnimatedSprite2D.play("idle")

func _ready():
	$mold_mite_1/AnimatedSprite2D.play("walk_forward")
	start_tween()

func start_tween():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($mold_mite_1, "position", offset, duration / 2)
	tween.tween_interval(2.0)
	tween.tween_property($mold_mite_1, "position", Vector2.ZERO, duration / 2)
	tween.tween_interval(2.0)

func _on_player_mite_1_collide() -> void:
	stop()
	var timer = get_tree().create_timer(5.)
	await timer.timeout
	start()
