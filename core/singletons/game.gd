# ----------------------------------------
# game.gd
# ----------------------------------------
# Game Entrypoint.
extends Node
const MODULE_NAME = "Game"

@onready var viewport_size : Vector2 = _get_viewport_size()
@onready var screen_size : Vector2 = DisplayServer.screen_get_size()

var current_scene : String = ""


# Entrypoint -----------------------------
func _ready() -> void:
	# Update viewport_size when viewport is being resized.()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	# Init PackageManager and Load .pck files
	Utils.load_packages(Data.PACKAGE_PATHS)
	# SPLASH_SCENE
	change_scene(Data.SPLASH_SCENE_PATH)
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
func change_scene(path: String, transition: String = "", use_sub_threads: bool = true) -> void:
	if transition.is_empty():
		# Load directly.
		Utils.loader.request(path, use_sub_threads).completed.connect(_on_loader_completed)
		pass
	else:
		# Init transition, connect to loader and add to child.
		var scene = load(transition).instantiate()
		scene.scene_signal = Utils.SceneSignal.new()
		scene.scene_signal.remove_old_scene_requested.connect(_on_remove_old_scene_requested)
		scene.scene_signal.set_new_scene_requested.connect(_on_set_new_scene_requested)
		Utils.loader.request(path, use_sub_threads).updated.connect(Callable(scene, "_on_loader_updated"))
		Utils.loader.request(path, use_sub_threads).completed.connect(Callable(scene, "_on_loader_completed"))
		add_child(scene)
		pass
	pass


# Connect to completed
func _on_loader_completed(path: String, resource: Resource) -> void:
	remove_old_scene()
	set_new_scene(path, resource)
	pass


# Remove old scene
# Note: If scene_file_path does not equal to "current_scene" it will be remained.
func remove_old_scene() -> void:
	if current_scene.is_empty() == false:
		for node in self.get_children():
			if node.get_scene_file_path() == current_scene:
				node.queue_free()
	current_scene = ""
	pass


# Set new scene
func set_new_scene(path: String, resource: Resource) -> void:
	var scene = resource.instantiate()
	# Connect SceneSignal.
	scene.scene_signal.change_scene_requested.connect(_on_change_scene_requested)
	# Add scene to child.
	add_child(scene)
	current_scene = path
	pass


# Call up from child scenes.
func _on_change_scene_requested(path: String, transition: String = "", use_sub_threads: bool = true) -> void:
	change_scene(path, transition, use_sub_threads)


# Call up from transitions
func _on_remove_old_scene_requested() -> void:
	remove_old_scene()


# Call up from transitions
func _on_set_new_scene_requested(path: String, resource: Resource) -> void:
	set_new_scene(path, resource)
