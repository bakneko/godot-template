# ----------------------------------------
# game.gd
# ----------------------------------------
# Game's scene container.
extends Node
const MODULE_NAME = "Game"

@onready var viewport_size : Vector2 = _get_viewport_size()
@onready var screen_size : Vector2 = DisplayServer.screen_get_size()

var current_scene : Node = null


# Entrypoint -----------------------------
func _ready() -> void:
	# Update viewport_size when viewport is being resized.()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	pass


# Viewport Size --------------------------
# Connect to viewport size change.
func _on_viewport_size_changed() -> void:
	viewport_size = _get_viewport_size()


# Update viewport_size
func _get_viewport_size() -> Vector2:
	return get_viewport().get_visible_rect().size


# Scene Management -----------------------
# Change scene to target by ResourceLoader
func change_scene(path: String, use_sub_threads: bool = true, transition: String = "") -> void:
	Utils.logger.info("Changing to scene: %s, use_sub_threads: %s..." % [path, use_sub_threads], MODULE_NAME)
	if transition.is_empty():
		# Load directly.
		Utils.loader.request(path, use_sub_threads).completed.connect(_on_loader_completed)
		pass
	else:
		Utils.logger.info("Use transitions: %s." % [transition], MODULE_NAME)
		# Init transition, connect to loader and add to child.
		var scene = load(transition).instantiate()
		scene.transignal.remove_old_scene_requested.connect(_on_remove_old_scene_requested)
		scene.transignal.set_new_scene_requested.connect(_on_set_new_scene_requested)
		add_child(scene)
		Utils.loader.request(path, use_sub_threads).updated.connect(Callable(scene, "_on_loader_updated"))
		Utils.loader.request(path, use_sub_threads).completed.connect(Callable(scene, "_on_loader_completed"))
		pass
	pass


# Connect to completed
func _on_loader_completed(path: String, resource: Resource) -> void:
	remove_old_scene()
	set_new_scene(path, resource)
	pass


# Remove old scene
func remove_old_scene() -> void:
	if current_scene != null:
		Utils.logger.info("%s was removed." % [current_scene.get_path()] , MODULE_NAME)
		current_scene.queue_free()
		current_scene = null
	pass


# Set new scene
func set_new_scene(_path: String, resource: Resource) -> void:
	var scene = resource.instantiate()
	# Add scene to child.
	add_child(scene)
	current_scene = scene
	Utils.logger.info("Current scene: %s." % [current_scene.get_path()] , MODULE_NAME)
	pass


# Call up from child scenes.
func _on_change_scene_requested(path: String, use_sub_threads: bool = true, transition: String = "") -> void:
	change_scene(path, use_sub_threads, transition)


# Call up from transitions.
func _on_remove_old_scene_requested() -> void:
	remove_old_scene()


# Call up from transitions.
func _on_set_new_scene_requested(path: String, resource: Resource) -> void:
	set_new_scene(path, resource)


# Class ----------------------------------
# Transition Signal for manage scene changes.
class Transignal:
	signal remove_old_scene_requested()
	signal set_new_scene_requested(path: String, resource: Resource)
