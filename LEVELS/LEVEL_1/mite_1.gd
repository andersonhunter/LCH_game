extends Node2D

@export var offset = Vector2(0., 16.)
@export var duration = 6.0

func _ready():
	$mold_mite/AnimatedSprite2D.play("walk_forward")
	start_tween()

func start_tween():
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($mold_mite, "position", offset, duration / 2)
	tween.tween_interval(2.0)
	tween.tween_property($mold_mite, "position", Vector2.ZERO, duration / 2)
	tween.tween_interval(2.0)
