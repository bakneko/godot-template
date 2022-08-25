# ----------------------------------------
# game.gd
# ----------------------------------------
# Game Entrypoint.
extends Node
const MODULE_NAME = "Game"

var screen_size: Vector2
@onready var splash = preload("res://core/ui/splash/splash.tscn")


# Entrypoint -----------------------------
func _ready():
	# Update screen size when screen is being resized.
	_update_screen_size()
	# Init PackageManager and Load .pck files
	var search_path = [
		"F:\\WorkTemp\\sandbox\\build\\contents",
		"F:\\WorkTemp\\sandbox\\build\\patches",
	]
	Utility.pckmgr.set_path(search_path)
	# Load
	Utility.logger.info("Game loaded!", MODULE_NAME)
	pass


# Screen Size ----------------------------
func _on_screen_resized():
	_update_screen_size()


func _update_screen_size():
	screen_size = get_viewport().get_visible_rect().size


# Scene Management -----------------------
func change_scene(scene: String, params = {}):
	if not Utility.file_exists(scene):
		printerr("[ERROR] Scene file not found: ", scene)
		return
	else:
		pass
		# use multi-thread
		#scenes.change_scene(scene, params)
