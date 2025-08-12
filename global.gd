extends Node

@export var speed = 75
var playerStats = {
	"name": "&null",
	"base health": 10,
	"current health": 10,
	"attack": 2,
	"defense": 2,
	"speed": 2,
	"exp": 0
}

var current_scene = null
var player_location = null
var position_array: Array  # Hold player's last 100 positions
var has_bat: bool = false
var music_pos: float = 0.
@export var music_volume: float = -10.0
var isDark = true

func goto_scene(path: String):
	# Call goto scene with deferred callback to allow things to finish
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path: String):
	# Switch the current scene
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
