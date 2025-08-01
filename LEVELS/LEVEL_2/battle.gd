extends Node2D

var returnScene

func _ready():
	hide()
	
func start():
	returnScene = get_tree().root.get_child(-1)
	get_tree().paused = true
	show()
	
func stop():
	hide()
	get_tree().paused = false
