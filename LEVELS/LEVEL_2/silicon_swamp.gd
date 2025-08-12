extends Node
var battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()
var bossBattleScene = preload("res://LEVELS/LEVEL_2/boss_battle_scene.tscn").instantiate()
var removeEnemy = null
var cosmicBrownie = preload("res://LEVELS/LEVEL_2/cosmic_brownie.tscn").instantiate()
var bossBattle: bool = false
@onready var player = $overworld/Player
signal startDialog(message)

@onready var sceneDialog = [
	[
		"[color=green]A powerful light washes over you...[/color]",
		"[color=green]You tremble at its power.[/color]",
		"[color=green]You fear you must grow stronger...[/color]"
	], 
	[
		"[color=green]A powerful light washes over you...[/color]",
		"[color=green]The strength within your heart [/color]",
		"[color=green]pulses even stronger.[/color]",
		"[color=green][wave]BRACE YOURSELF[/wave][/color]"
	],
	[
		"[color=green]You feel the light before you [/color]",
		"[color=green]dissipate, returning to the world. [/color]",
		"[color=green]Still, you feel a sense of unease...[/color]",
		"[color=green]You will have to check back... [/color]",
		"[color=green]... when the dev is done![/color]",
		"[color=green]Thank you for playing <3 <3[/color]"
	]
]

func startBattle():
	removeEnemy = $overworld/Player.get_last_slide_collision().get_collider()
	removeEnemy.get_node("CollisionShape2D").disabled = true
	$overworld.propagate_call("hide")
	$overworld/Player/CollisionShape2D.disabled = true
	self.add_child(battleScene)
	battleScene.battleDone.connect(_on_battleDone)

func startBossBattle():
	if Global.has_bat:
		$overworld.get_node("bat").hide()
	var dialog = player.get_node("Dialogue")
	if Global.playerStats["level"] < 2:
		player.speed = 0
		player.position += Vector2(0., 16.)
		dialog.show()
		startDialog.emit(sceneDialog[0])
		await dialog.textCompleted
		dialog.hide()
		$overworld/boss/CollisionShape2D.disabled = true
		if Global.has_bat:
			$overworld.get_node("bat").show()
		player.speed = Global.speed
		$overworld/boss/CollisionShape2D.disabled = false
	else:
		removeEnemy = $overworld/Player.get_last_slide_collision().get_collider()
		player.get_node("CollisionShape2D").disabled = true
		bossBattle = true
		player.speed = 0
		player.position += Vector2(0., 16.)
		$overworld/bossTransition.volume_db = Global.music_volume
		dialog.show()
		startDialog.emit(sceneDialog[1])
		await dialog.textCompleted
		$overworld/bossTransition.play()
		await $overworld/bossTransition.finished
		dialog.hide()
		$overworld.propagate_call("hide")
		self.add_child(bossBattleScene)
		bossBattleScene.battleDone.connect(_on_battleDone)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $overworld/Player.get_last_slide_collision():
		var collider = $overworld/Player.get_last_slide_collision().get_collider()
		match collider.name:
			"slime":
				startBattle()
			"slime2":
				startBattle()
			"slime3":
				startBattle()
			"boss":
				startBossBattle()
			"cosmicBrownie":
				collider.get_node("CollisionShape2D").disabled = true
				collider.queue_free()
				Global.playerStats["current health"] = clamp(
					Global.playerStats["current health"] + 3,
					0,
					Global.playerStats["base health"]
				)

func _on_battleDone():
	if bossBattle:
		print(get_node("bossBattleScene"))
		self.remove_child(self.get_node("bossBattleScene"))
		removeEnemy.queue_free()
		await removeEnemy.tree_exited
		$overworld.propagate_call("show")
		$overworld/Player/enterPrompt.hide()
		$overworld/Player/Dialogue.hide()
		$overworld/Player/enterNewAreaPrompt.hide()
		$overworld/Player/levelUp.hide()
		var dialog = player.get_node("Dialogue")
		Global.isDark = false
		dialog.show()
		startDialog.emit(sceneDialog[2])
		await dialog.textCompleted
		dialog.hide()
		get_tree().quit()
	else:
		self.remove_child(self.get_node("battleScene"))
		self.add_child(cosmicBrownie)
		cosmicBrownie.position = removeEnemy.position
		cosmicBrownie.get_node("AnimatedSprite2D").play("default")
		removeEnemy.queue_free()
		await removeEnemy.tree_exited
		$overworld/Player/CollisionShape2D.disabled = false
		$overworld.propagate_call("show")
		$overworld/Player/enterPrompt.hide()
		$overworld/Player/Dialogue.hide()
		$overworld/Player/enterNewAreaPrompt.hide()
		$overworld/Player/levelUp.hide()
		if Global.levelUp():
			$overworld/Player/levelUp.show()
			await get_tree().create_timer(1.0).timeout
			$overworld/Player/levelUp.hide()
		battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()
		cosmicBrownie = preload("res://LEVELS/LEVEL_2/cosmic_brownie.tscn").instantiate()
