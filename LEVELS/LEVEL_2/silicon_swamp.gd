extends Node
var battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()
var removeEnemy = null
var cosmicBrownie = preload("res://LEVELS/LEVEL_2/cosmic_brownie.tscn").instantiate()

func startBattle():
	removeEnemy = $overworld/Player.get_last_slide_collision().get_collider()
	removeEnemy.get_node("CollisionShape2D").disabled = true
	$overworld.propagate_call("hide")
	$overworld/Player/CollisionShape2D.disabled = true
	self.add_child(battleScene)
	battleScene.battleDone.connect(_on_battleDone)

func startBossBattle():
	pass

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
