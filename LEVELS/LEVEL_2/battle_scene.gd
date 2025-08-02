extends Node2D
var enemyStats = {
	"slime": {
		"base health": 3,
		"current health": 3,
		"attack": 1,
		"defense": 1,
		"speed": 1
	}
}
var sceneCharacters: Dictionary # {char: {stats}...}
var turnQueue: Array # [char: Node2D, char: Node2D, ...]

func setHealthBar(unit, health, maxHealth):
	# Sets the unit's health bar
	var healthBar: ProgressBar = unit.get_node("ProgressBar")
	healthBar.max_value = maxHealth
	healthBar.value = health
	var healthFlavor: Label = unit.get_node("Label")
	healthFlavor.text = "HP: %d/%d" % [healthBar.value, healthBar.max_value]

var player = preload("res://LEVELS/LEVEL_2/player_battle.tscn").instantiate()

func addEnemies():
	# Adds enemies to scene depending on how many enemies spawn [1..3]
	var numEnemies = RandomNumberGenerator.new().randi_range(1, 3)
	if numEnemies == 2:
		for n in range(1, 3):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)
			sceneCharacters[enemy] = enemyStats[enemy.name]
			turnQueue.push_back(enemy)
			setHealthBar(enemy, sceneCharacters[enemy]["current health"], sceneCharacters[enemy]["base health"])
	else:
		for n in range(0, numEnemies):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)
			sceneCharacters[enemy] = enemyStats[enemy.name]
			turnQueue.push_back(enemy)
			setHealthBar(enemy, sceneCharacters[enemy]["current health"], sceneCharacters[enemy]["base health"])

func sortTurnQueue():
	# Sort the turn queue based on speed
	turnQueue.sort_custom(
		func(a, b): return sceneCharacters[a]["speed"] > sceneCharacters[b]["speed"]
		)

func playerTurn():
	pass

func _ready() -> void:
	get_node("player").add_child(player)
	sceneCharacters[player] = Global.playerStats
	turnQueue.push_back(player)
	setHealthBar(player, Global.playerStats["current health"], Global.playerStats["base health"])
	addEnemies()
	sortTurnQueue()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print(event.as_text())

func _on_attack_pressed() -> void:
	print("attack!")

func _on_defend_pressed() -> void:
	print("defend!")
