extends Node
var leave_house = "res://LEVELS/LEVEL_1/little_endian.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_leave_house_body_entered(body: Node2D) -> void:
	if body == $Player:
		print(leave_house)
		Global.goto_scene(leave_house)
