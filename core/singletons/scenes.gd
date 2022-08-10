class_name Scenes
extends Node

signal change_started
signal change_finished

const MINIMUM_TRANSITION_DURATION = 200 # ms

@onready var transitions: Transition = get_node_or_null("/root/Transitions")
@onready var _loader = preload("res://core/classes/loader.gd").new()

# Parameter Caching.
var _params = {}
var _loading_start_time = 0


# ----------------------------------------
# Notes
# ----------------------------------------
# When the loading of a new scene is completed, it calls
# two methods on the new loaded scene (if they are defined):
# 1. `pre_start(params)`: called as soon as the scene is loaded in memory.
#    It passes the `params` object received by
#    `Game.change_scene(new_scene, params)`.
# 2. `start()`: called when the scene transition is finished and when the
#    gameplay input is unlocked.


# ----------------------------------------
# Entrypoints
# ----------------------------------------


func _ready():
	# Load modules
	_loader.name = "ResourceLoader"
	add_child(_loader)
	# Connect signals
	if transitions:
		_loader.connect("resource_stage_loaded", transitions, "_on_resource_stage_loaded")
	var _t = connect("change_started", self, "_on_change_started")
	# Set pause mode
	pause_mode = Node.PAUSE_MODE_PROCESS
	# Add history to scene history data
	_history.add(_get_current_scene_node().filename, null)


func get_last_loaded_scene_data() -> SceneData:
	return _history.get_last_loaded_scene_data()


func _get_current_scene_node() -> Node:
	return get_tree().current_scene


func _set_new_scene(resource: PackedScene):
	var current_scene = _get_current_scene_node()
	current_scene.queue_free()
	var instanced_scn: Node = resource.instance() # triggers _init
	get_tree().root.add_child(instanced_scn) # triggers _ready
	get_tree().current_scene = instanced_scn
	if transitions:
		transitions.fade_out()
	if instanced_scn.has_method("pre_start"):
		instanced_scn.pre_start(_params)
	if transitions:
		yield(transitions.anim, "animation_finished")
	if instanced_scn.has_method("start"):
		instanced_scn.start()
	emit_signal("change_finished")
	_params = {}
	_loading_start_time = 0


func _transition_appear(params):
	if transitions:
		transitions.fade_in(params)


# Multithread interactive loading
func change_scene(new_scene: String, params = {}):
	emit_signal("change_started", new_scene, params)
	_params = params
	_loading_start_time = OS.get_ticks_msec()
	_transition_appear(params)
	_loader.connect("resource_loaded", self, "_on_resource_loaded", [], CONNECT_ONESHOT)
	_loader.load_scene(new_scene)


func _on_change_started(new_scene, params):
	_history.add(new_scene, params)


func _on_resource_loaded(resource):
	if transitions and transitions.is_transition_in_playing():
		yield(transitions.anim, "animation_finished")
	var load_time = OS.get_ticks_msec() - _loading_start_time # ms
	print("[INFO] {scn} loaded in {elapsed}ms.".format({
		'scn': resource.resource_path,
		'elapsed': load_time
	}))
	# Artificially wait some time in order to have a gentle scene transition
	if transitions and load_time < MINIMUM_TRANSITION_DURATION:
		yield(get_tree().create_timer((MINIMUM_TRANSITION_DURATION - load_time) / 1000.0), "timeout")
	_set_new_scene(resource)
