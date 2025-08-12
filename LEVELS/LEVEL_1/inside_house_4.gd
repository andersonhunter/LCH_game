extends Node
var leave_house = "res://LEVELS/LEVEL_1/little_endian.tscn"

@onready var batDialog = [
	[
		"[color=green]Oh, hello! You're looking for Ada? [/color]",
		"[color=green]Oh, that's me![/color]",
		"[color=green]You want to play in the [/color][wave][color=red]swa[/color][color=blue]mps?[/color][/wave]",
		"[color=green]Sure! I'll follow... what was that?[/color]",
		"[color=green]Let's go check outside![/color]"
	]
]
@onready var player = $Player
signal startDialog(message: Array)

func transition() -> void:
	# Play transition animation
	$Player.speed = 0
	$SceneTransitionRect.get_child(0).play("fade")
	await get_tree().create_timer(0.5).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BatSolo.show()
	if Global.has_bat:
			$BatSolo.hide()
			$BatSolo/CollisionShape2D.disabled = true
	if Global.isDark:
		$darkOverworld.show()
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

func _on_player_start_dialogue(collider: CharacterBody2D) -> void:
	var dialogue = player.get_node("Dialogue")
	collider.get_node("CollisionShape2D").disabled = true
	player.speed = 0.
	dialogue.show()
	startDialog.emit(batDialog[0])
	await dialogue.textCompleted
	dialogue.hide()
	$BatSolo.hide()
	Global.has_bat = true
	Global.isDark = true
	player.speed = Global.speed
	await get_tree().create_timer(1.0).timeout
	collider.get_node("CollisionShape2D").disabled = false
