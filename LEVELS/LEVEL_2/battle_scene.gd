extends Node2D

var isDefending: bool = false
var defends: int = 3
signal battleDone

var enemyStats = {
	"slime": {
		"base health": 3,
		"current health": 3,
		"attack": 1,
		"defense": 1,
		"speed": 1,
	}
}

var player = preload("res://LEVELS/LEVEL_2/player_battle.tscn").instantiate()
var sceneCharacters: Dictionary # {char: {stats}...}
var turnQueue: Array # [char: Node2D, char: Node2D, ...]
var enemies: Array

func setLabelText(text: String) -> void:
	$battleUI/textBox.show()
	var tween: Tween = create_tween()
	tween.tween_property($battleUI/textBox, "visible_ratio", 1.0, 1.5).from(0.0)
	$battleUI/textBox.text = text
	await tween.finished
	return

func setHealthBar(unit, health, maxHealth):
	# Sets the unit's health bar
	var healthBar: ProgressBar = unit.get_node("ProgressBar")
	healthBar.max_value = maxHealth
	healthBar.value = clamp(health, 0, maxHealth)
	var healthFlavor: Label = unit.get_node("Label")
	healthFlavor.text = "HP: %d/%d" % [healthBar.value, healthBar.max_value]

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

func characterDeath(character: Node2D) -> void:
	match character.name:
		"player":
			print("Character died X.X")
			return
		_:
			enemies.erase(character)
			sceneCharacters.erase(character)
			character.get_parent().free()
			if enemies.size() == 0:
				# Switch scenes
				await get_tree().create_timer(0.25).timeout
				# Remove scene from tree here
				battleDone.emit()
			return

func enemyTurn(enemy: Node2D):
	$battleUI/commands.hide()
	var damage = enemyStats[enemy.name]["attack"]
	damage -= Global.playerStats["defense"]
	if damage <= 0:
		damage = 1
	if isDefending:
		damage = 0
	var damageText = "%s attacks for %d damage" % [enemy.name, damage]
	setLabelText(damageText)
	await get_tree().create_timer(2.).timeout
	Global.playerStats["current health"] -= damage
	setHealthBar(
		player, 
		Global.playerStats["current health"], 
		Global.playerStats["base health"])
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	takeTurn()

func playerTurn():
	isDefending = false
	$battleUI/commands/defend.disabled = false
	for n in $battleUI/enemySelect.get_children():
		n.disabled = true
		n.hide()
	if defends == 0:
		$battleUI/commands/defend.disabled = true
		$battleUI/commands/defend.hide()
	$battleUI/commands.show()
	$battleUI/commands/attack.grab_focus()

func takeTurn():
	$battleUI/commands.hide()
	$battleUI/enemySelect.hide()
	var turn = turnQueue.pop_front()
	while not is_instance_valid(turn):  # Guard against invalid nodes
		turn = turnQueue.pop_front()
	turnQueue.push_back(turn)
	if turn.name == player.name:
		playerTurn()
	else:
		enemyTurn(turn)

func attack(enemy: int) -> void:
	var foe = $enemies.get_children()[enemy].get_children()[0]
	sceneCharacters[foe]["current health"] -= Global.playerStats["attack"]
	setHealthBar(foe, sceneCharacters[foe]["current health"], sceneCharacters[foe]["base health"])
	if sceneCharacters[foe]["current health"] <= 0:
		characterDeath(foe)
	takeTurn()

func _ready() -> void:
	$battleUI/commands.hide()
	get_node("player").add_child(player)
	sceneCharacters[player] = Global.playerStats
	turnQueue.push_back(player)
	setHealthBar(player, Global.playerStats["current health"], Global.playerStats["base health"])
	addEnemies()
	sortTurnQueue()
	$Camera2D.make_current()
	takeTurn()

func _on_attack_pressed() -> void:
	$battleUI/commands.hide()
	await setLabelText("Attack who?")
	enemies = $enemies.get_children().map(
		func(n): return n.get_children()[0]
	)
	$battleUI/enemySelect.show()
	for n in range(enemies.size()):
		$battleUI/enemySelect.get_children()[n].text = enemies[n].name
		$battleUI/enemySelect.get_children()[n].show()
		$battleUI/enemySelect.get_children()[n].disabled = false
		if n == 0:
			$battleUI/enemySelect/enemy1.grab_focus()

func _on_defend_pressed() -> void:
	$battleUI/commands.hide()
	isDefending = true
	defends -= 1
	player.get_node("shields").get_children()[defends].hide()
	match defends:
		1:
			setLabelText("%d defend remaining..." % [defends])
		_:
			setLabelText("%d defends remaining..." % [defends])
	await get_tree().create_timer(2.).timeout
	$battleUI/commands/defend.disabled = true
	$battleUI/commands.show()
	$battleUI/commands/attack.grab_focus()

func _on_enemy_1_focus_entered() -> void:
	if enemies.size() > 0:
		enemies[0].get_node("targeted").show()
		enemies[0].get_node("targeted").play()

func _on_enemy_1_focus_exited() -> void:
	if enemies.size() > 0:
		enemies[0].get_node("targeted").hide()
		enemies[0].get_node("targeted").stop()

func _on_enemy_2_focus_entered() -> void:
	if enemies.size() > 0:
		enemies[1].get_node("targeted").show()
		enemies[1].get_node("targeted").play()

func _on_enemy_2_focus_exited() -> void:
	if enemies.size() > 0:
		enemies[1].get_node("targeted").hide()
		enemies[1].get_node("targeted").stop()

func _on_enemy_3_focus_entered() -> void:
	if enemies.size() > 0:
		enemies[2].get_node("targeted").show()
		enemies[2].get_node("targeted").play()

func _on_enemy_3_focus_exited() -> void:
	if enemies.size() > 0:
		enemies[2].get_node("targeted").hide()
		enemies[2].get_node("targeted").stop()

func _on_enemy_1_pressed() -> void:
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	attack(0)

func _on_enemy_2_pressed() -> void:
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	attack(1)

func _on_enemy_3_pressed() -> void:
	$battleUI/textBox.text = ""
	$battleUI/textBox.hide()
	attack(2)
