extends Node
var battleScene = preload("res://LEVELS/LEVEL_2/battle_scene.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $overworld/Player.get_last_slide_collision():
		match $overworld/Player.get_last_slide_collision().get_collider().name:
			"slime":
				$overworld.propagate_call("hide")
				$overworld/Player/CollisionShape2D.disabled = true
				self.add_child(battleScene)
