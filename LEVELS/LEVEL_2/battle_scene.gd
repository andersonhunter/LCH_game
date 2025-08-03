extends Node2D

signal attack

var enemyStats = {
	"slime": {
		"base health": 3,
		"current health": 3,
		"attack": 1,
		"defense": 1,
		"speed": 2
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
	# Remove superfluous enemies
	match numEnemies:
		1:
			$enemies/enemy2.queue_free()
			$enemies/enemy3.queue_free()
		2:
			$enemies/enemy1.queue_free()
	for parent in $enemies.get_children():
		var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
		parent.add_child(enemy)
		sceneCharacters[enemy] = enemyStats[enemy.name]
		turnQueue.push_back(enemy)
		setHealthBar(
			enemy, 
			sceneCharacters[enemy]["current health"], 
			sceneCharacters[enemy]["base health"]
			)

func sortTurnQueue():
	# Sort the turn queue based on speed
	turnQueue.sort_custom(
		func(a, b): return sceneCharacters[a]["speed"] > sceneCharacters[b]["speed"]
		)

func playerTurn():
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	$battleUI/commands.show()
	$battleUI/commands/attack.grab_focus()
	await attack
	$battleUI/commands.hide()
	$battleUI/textBox.text = "Attack who?"
	$battleUI/textBox.show()
	$enemies.get_children()[0].get_children()[0].get_node("targeted").show()
	$enemies.get_children()[0].get_children()[0].get_node("targeted").play()

func _ready() -> void:
	get_node("player").add_child(player)
	sceneCharacters[player] = Global.playerStats
	turnQueue.push_back(player)
	setHealthBar(player, Global.playerStats["current health"], Global.playerStats["base health"])
	addEnemies()
	sortTurnQueue()
	var firstTurn = turnQueue.pop_front()
	playerTurn()

func _on_attack_pressed() -> void:
	attack.emit()

func _on_defend_pressed() -> void:
	pass # Replace with function body.
