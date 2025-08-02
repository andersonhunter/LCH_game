extends Node2D
var enemies = {
	"slime": {
		"health": 3,
		"attack": 1,
		"defense": 1
	}
}

var player = preload("res://LEVELS/LEVEL_2/player_battle.tscn").instantiate()

func addEnemies():
	# Adds enemies to scene depending on how many enemies spawn [1..3]
	var numEnemies = RandomNumberGenerator.new().randi_range(1, 3)
	if numEnemies == 2:
		for n in range(1, 3):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)
	else:
		for n in range(0, numEnemies):
			var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
			var parent := $enemies.get_children()[n]
			parent.add_child(enemy)

func _ready() -> void:
	get_node("player").add_child(player)
	addEnemies()
