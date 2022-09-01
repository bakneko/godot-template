# ----------------------------------------
# data.gd
# ----------------------------------------
# Stores all data and config presets.
extends Node
const MODULE_NAME = "GlobalData"

# Scene Configs --------------------------
const SPLASH_SCENE_PATH : String = "res://core/ui/splash/splash.tscn"
const MAIN_SCENE_PATH : String = "res://template/maps/placeholder/placeholder.tscn"
const TRANSITION_IMAGE_PATH : String = "res://core/ui/transitions/transition_image.tscn"

# Resource & Packages --------------------
var LOADER_WAIT_TIME : float = 0.5
var PACKAGE_ROOT : String = OS.get_executable_path().get_base_dir()
var PACKAGE_PATHS : Array = [ 
	PACKAGE_ROOT.path_join("contents"),
	PACKAGE_ROOT.path_join("patches"),
]
