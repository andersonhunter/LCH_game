extends Node
var battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_child(battleScene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
