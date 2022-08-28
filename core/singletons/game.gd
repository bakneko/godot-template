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


# Entrypoint -----------------------------
func _ready() -> void:
	# Update viewport_size when viewport is being resized.()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	# Init PackageManager and Load .pck files
	Utility.load_packages(package_paths)
	# change to startup scene
	pass


# Viewport Size --------------------------
# Connect to viewport size change.
func _on_viewport_size_changed() -> void:
	viewport_size = _get_viewport_size()


# Update viewport_size
func _get_viewport_size() -> Vector2:
	return get_viewport().get_visible_rect().size


# Scene Management -----------------------
func change_scene(path: String, use_transition: bool = false) -> void:
	
	pass
