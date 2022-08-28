# ----------------------------------------
# game.gd
# ----------------------------------------
# Game Entrypoint.
extends Node
const MODULE_NAME = "Game"

var viewport_size : Vector2 = _on_viewport_size_changed()
var screen_size : Vector2 = DisplayServer.screen_get_size()

@onready var splash = preload("res://core/ui/splash/splash.tscn")


# Entrypoint -----------------------------
func _ready() -> void:
	# Update viewport_size when viewport is being resized.
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	# Init PackageManager and Load .pck files
	
	# Write log.
	pass


# Viewport Size --------------------------
func _on_viewport_size_changed():
	viewport_size = get_viewport().get_visible_rect().size


# Scene Management -----------------------
func change_scene(path: String, params = {}):
	if not Utility.file_exists(scene):
		printerr("[ERROR] Scene file not found: ", scene)
		return
	else:
		pass
		# use multi-thread
		#scenes.change_scene(scene, params)
