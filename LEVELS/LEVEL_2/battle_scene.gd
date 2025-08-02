extends Node2D
var enemyStats = {
	"slime": {
		"health": 3,
		"attack": 1,
		"defense": 1,
		"speed": 1
	}
}

var enemies: Array
var turnQueue: Array

var player = preload("res://LEVELS/LEVEL_2/player_battle.tscn").instantiate()

func addEnemies():
	# Adds enemies to scene depending on how many enemies spawn [1..3]
	var numEnemies = RandomNumberGenerator.new().randi_range(1, 3)
	if numEnemies == 2:
		for n in range(1, 3):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)
			enemies.push_back(enemy)
	else:
		for n in range(0, numEnemies):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)
			enemies.push_back(enemy)

func sortTurnQueue():
	# Sort the turn queue based on speed
	enemies.sort_custom(
		func(a, b): return enemyStats[a.name]["speed"] > enemyStats[b.name]["speed"]
		)
	turnQueue = enemies.duplicate()
	for i in range(turnQueue.size()):
		if enemyStats[turnQueue[i].name]["speed"] <= Global.playerStats["speed"]:
			turnQueue.insert(i, player)
			break
		elif i == turnQueue.size() - 1:
			turnQueue.push_back(player)

func playerTurn():
	await $battleUI.accept_event()

func _ready() -> void:
	get_node("player").add_child(player)
	addEnemies()
	sortTurnQueue()

func _on_attack_pressed() -> void:
	print("attack!")

func _on_defend_pressed() -> void:
	print("defend!")
