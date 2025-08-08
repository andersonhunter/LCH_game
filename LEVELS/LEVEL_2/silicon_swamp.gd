extends Node
var battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()
var removeEnemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func startBattle():
	removeEnemy = $overworld/Player.get_last_slide_collision().get_collider()
	$overworld.propagate_call("hide")
	$overworld/Player/CollisionShape2D.disabled = true
	self.add_child(battleScene)
	battleScene.battleDone.connect(_on_battleDone)

func startBossBattle():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $overworld/Player.get_last_slide_collision():
		match $overworld/Player.get_last_slide_collision().get_collider().name:
			"slime":
				startBattle()
			"slime2":
				startBattle()
			"slime3":
				startBattle()
			"boss":
				startBossBattle()

func _on_battleDone():
	self.remove_child(self.get_node("battleScene"))
	removeEnemy.queue_free()
	await removeEnemy.tree_exited
	$overworld/Player/CollisionShape2D.disabled = false
	$overworld.propagate_call("show")
	battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()
