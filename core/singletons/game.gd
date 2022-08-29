# ----------------------------------------
# game.gd
# ----------------------------------------
# Game Entrypoint.
extends Node
const MODULE_NAME = "Game"

@onready var viewport_size : Vector2 = _get_viewport_size()
@onready var screen_size : Vector2 = DisplayServer.screen_get_size()

var package_root : String = OS.get_executable_path().get_base_dir()
var package_paths : Array = [
	package_root.plus_file("contents"),
	package_root.plus_file("patches"),
]

var current_scene : String = ""


# Configurations -------------------------
const SPLASH_SCENE = "res://core/ui/splash/splash.tscn"
const MAIN_SCENE = "res://template/maps/placeholder/placeholder.tscn"


# Entrypoint -----------------------------
func _ready() -> void:
	# Update viewport_size when viewport is being resized.()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	# Init PackageManager and Load .pck files
	Utility.load_packages(package_paths)
	# SPLASH_SCENE
	change_scene("res://core/ui/splash/splash.tscn")
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
		Utility.loader.request(path, use_sub_threads).completed.connect(_on_loader_completed)
		pass
	else:
		# Use transition.
		
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
	add_child(resource.instantiate())
	current_scene = path
	pass
