# ----------------------------------------
# game.gd
# ----------------------------------------
# Game Entrypoint.
# Eg: `Game.change_scene("res://template/maps/gameplay/gameplay.tscn")`
extends Node


var screen_size: Vector2

@onready var pckmgr = preload("res://core/classes/pckmgr.gd").new()
#@onready var logger = preload("res://core/classes/loader.gd").new()
@onready var splash = preload("res://core/ui/splash/splash.tscn").instantiate()


# Entrypoint -----------------------------
func _enter_tree() -> void:
	# Update screen size when screen is being resized.
	_update_screen_size()
	# Init Logger
	
	# Init PackageManager
	

func _ready() -> void:
	
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
