extends Node2D
var enemies = {
	"slime": {
		"health": 3,
		"attack": 1,
		"defense": 1,
		"res": "res://SPRITES/ENEMIES/slime_1.png"
	}
}

var player = preload("res://LEVELS/LEVEL_2/player_battle.tscn").instantiate()

func addEnemies():
	var numEnemies = RandomNumberGenerator.new().randi_range(1, 3)
	for n in range(0, numEnemies):
		var enemy = load("res://LEVELS/LEVEL_2/slime.tscn").instantiate()
		var parent := $enemies.get_children()[n]
		# Wait until parent is ready, then add bat as sibling
		parent.add_child(enemy)

func _ready() -> void:
	get_node("player").add_child(player)
	addEnemies()
