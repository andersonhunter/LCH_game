extends Node
var leave_house = "res://LEVELS/LEVEL_1/little_endian.tscn"

func transition() -> void:
	# Play transition animation
	$Player.speed = 0
	$SceneTransitionRect.get_child(0).play("fade")
	await get_tree().create_timer(0.5).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.has_bat:
			$BatSolo.hide()
			$BatSolo/CollisionShape2D.disabled = true
	$bgm.volume_db = Global.music_volume
	$bgm.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.has_bat:
		if $Player.get_real_velocity() != Vector2.ZERO && !$Bat.visible:
			$Bat.show()

func _on_leave_house_body_entered(body: Node2D) -> void:
	if body == $Player:
		await transition()
		Global.goto_scene(leave_house)
