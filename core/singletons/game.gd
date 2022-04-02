extends Node

onready var transitions = get_node_or_null("/root/Transitions")
var pause_scenes_on_transitions = false
var prevent_input_on_transitions = true

var scenes: Scenes
var size: Vector2


# ----------------------------------------
# Notes
# ----------------------------------------
# Game autoload. Use `Game` global variable to access.
# Eg: `Game.change_scene("res://template/maps/gameplay/gameplay.tscn")`


# ----------------------------------------
# Entrypoints
# ----------------------------------------


func _enter_tree() -> void:
	# Need to make "prevent_input_on_transitions" work even if the game is paused.
	pause_mode = Node.PAUSE_MODE_PROCESS 

	# Update screen size when screen is being resized.
	_update_screen_size()
	var _t = get_tree().connect("screen_resized", self, "_on_screen_resized")

	# If Transition exists, connect signal.
	if transitions:
		transitions.connect("transition_started", self, "_on_Transitions_transition_started")
		transitions.connect("transition_finished", self, "_on_Transitions_transition_finished")


func _ready() -> void:
	# Add 'Scenes' singleton node.
	scenes = preload("res://core/singletons/scenes.gd").new()
	scenes.name = "Scenes"
	get_node("/root/").call_deferred("add_child", scenes)


func _input(_event: InputEvent):
	if transitions and prevent_input_on_transitions and transitions.is_displayed():
		# Prevents all inputs while a graphic transition is playing.
		get_tree().set_input_as_handled()


# ----------------------------------------
# Acquire Screen Size
# ----------------------------------------


func _on_screen_resized():
	_update_screen_size()


func _update_screen_size():
	size = get_viewport().get_visible_rect().size


# ----------------------------------------
# Change Scene
# ----------------------------------------


func change_scene(scene: String, params = {}):
	if not Utils.file_exists(scene):
		printerr("[ERROR] Scene file not found: ", scene)
		return
	else:
		# use multi-thread
		scenes.change_scene(scene, params)


## Restart current scene.
## If params is not {}, restart with given params.
func restart_scene(params = {}):
	var scene_data = scenes.get_last_loaded_scene_data()
	if params == {}:
		change_scene(scene_data.path, scene_data.params)
	else:
		change_scene(scene_data.path, params)


# ----------------------------------------
# Transitions Singal
# ----------------------------------------


func _on_Transitions_transition_started(_anim_name):
	if pause_scenes_on_transitions:
		get_tree().paused = true


func _on_Transitions_transition_finished(_anim_name):
	if pause_scenes_on_transitions:
		get_tree().paused = false
