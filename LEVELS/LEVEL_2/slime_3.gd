extends AnimatableBody2D

@export var offset = Vector2(-80., -154.)
@export var endOffset = Vector2(-66., -154.)
@export var duration = 6.0
var tween: Tween

func start():
	# $AnimatedSprite2D.play("walk_forward")
	tween.play()
	$CollisionShape2D.disabled = false
	
func stop():
	$CollisionShape2D.disabled = true
	tween.pause()
	#$AnimatedSprite2D.play("idle")

func _ready():
	#$AnimatedSprite2D.play("walk_forward")
	start_tween()

func start_tween():
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", offset, duration / 2)
	tween.tween_interval(2.0)
	tween.tween_property(self, "position", endOffset, duration / 2)
	tween.tween_interval(2.0)

#func _on_player_mite_1_collide() -> void:
	#stop()
	#var timer = get_tree().create_timer(5.)
	#await timer.timeout
	#start()
