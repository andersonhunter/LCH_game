extends Node2D

var isDefending: bool = false
var isAttacking: bool = true

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
var enemies: Array

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
			$enemies/enemy2.free()
			$enemies/enemy3.free()
		2:
			$enemies/enemy1.free()
	for parent in $enemies.get_children():
		var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
		parent.add_child(enemy)
		sceneCharacters[enemy] = enemyStats[enemy.name].duplicate()
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

func enemyTurn():
	takeTurn()

func playerTurn():
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	$battleUI/commands.show()
	$battleUI/commands/attack.grab_focus()

func takeTurn():
	$battleUI/commands.hide()
	$battleUI/enemySelect.hide()
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	var turn = turnQueue.pop_front()
	while not is_instance_valid(turn):  # Guard against invalid nodes
		turn = turnQueue.pop_front()
	turnQueue.push_back(turn)
	if turn.name == player.name:
		playerTurn()
	else:
		enemyTurn()

func attack(enemy: int) -> void:
	var foe = $enemies.get_children()[enemy].get_children()[0]
	print(foe)
	print(sceneCharacters)
	sceneCharacters[foe]["current health"] -= Global.playerStats["attack"]
	setHealthBar(foe, sceneCharacters[foe]["current health"], sceneCharacters[foe]["base health"])
	takeTurn()

func _ready() -> void:
	$battleUI/commands.hide()
	get_node("player").add_child(player)
	sceneCharacters[player] = Global.playerStats
	turnQueue.push_back(player)
	setHealthBar(player, Global.playerStats["current health"], Global.playerStats["base health"])
	addEnemies()
	sortTurnQueue()
	takeTurn()

func _on_attack_pressed() -> void:
	$battleUI/commands.hide()
	$battleUI/textBox.text = "Attack who?"
	$battleUI/textBox.show()
	isAttacking = true
	enemies = $enemies.get_children().map(
		func(n): return n.get_children()[0]
	)
	$battleUI/enemySelect.show()
	for n in range(enemies.size()):
		$battleUI/enemySelect.get_children()[n].text = enemies[n].name
		$battleUI/enemySelect.get_children()[n].show()
		$battleUI/enemySelect.get_children()[n].disabled = false
	$battleUI/enemySelect/enemy1.grab_focus()

func _on_defend_pressed() -> void:
	isDefending = true
	takeTurn()

func _on_enemy_1_focus_entered() -> void:
	enemies[0].get_node("targeted").show()
	enemies[0].get_node("targeted").play()

func _on_enemy_1_focus_exited() -> void:
	enemies[0].get_node("targeted").hide()
	enemies[0].get_node("targeted").stop()

func _on_enemy_2_focus_entered() -> void:
	enemies[1].get_node("targeted").show()
	enemies[1].get_node("targeted").play()

func _on_enemy_2_focus_exited() -> void:
	enemies[1].get_node("targeted").hide()
	enemies[1].get_node("targeted").stop()

func _on_enemy_3_focus_entered() -> void:
	enemies[2].get_node("targeted").show()
	enemies[2].get_node("targeted").play()

func _on_enemy_3_focus_exited() -> void:
	enemies[2].get_node("targeted").hide()
	enemies[2].get_node("targeted").stop()

func _on_enemy_1_pressed() -> void:
	attack(0)

func _on_enemy_2_pressed() -> void:
	attack(1)

func _on_enemy_3_pressed() -> void:
	attack(2)
