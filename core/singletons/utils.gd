# ----------------------------------------
# utility.gd
# ----------------------------------------
# Functions for tool use.
extends Node
const MODULE_NAME = "Utility"

@onready var logger = load("res://core/classes/logger.gd").new()
@onready var pckmgr = load("res://core/classes/pckmgr.gd").new()
@onready var loader = load("res://core/classes/loader.gd").new()


# Ready ----------------------------------
func _ready():
	# Register logger
	pckmgr.set_logger(logger)
	loader.set_logger(logger) 
	# Add LoaderUpdateStatusTimer
	var timer = Timer.new()
	timer.name = "LoaderUpdateStatusTimer"
	timer.wait_time = Data.LOADER_WAIT_TIME
	add_child(timer)
	loader.set_timer(timer)
	pass


# File Operations ------------------------
# Get files in folder and subfolders. Regex Match is supported.
func get_files_recursive(path: String, regex: RegEx = null) -> Array:
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		var file := dir.get_next()
		while file != "":
			if dir.current_is_dir():
				files += get_files_recursive(dir.get_current_dir().path_join(file), regex)
			else:
				var file_path = dir.get_current_dir().path_join(file)
				if regex != null:
					if regex.search(file_path):
						files.append(file_path)
				else:
					files.append(file_path)
			file = dir.get_next()
		return files
	else:
		logger.error("A error occured when trying to open directory: %s" % path, MODULE_NAME)
		return []


# PackageManager -------------------------
# Load Packages from given paths (with order)
func load_packages(paths: Array) -> void:
	if OS.has_feature("standalone"):
		# Load if exported.
		pckmgr.set_path(paths)
		pckmgr.load_packages()
	else:
		logger.warning("This project seems runs in editor, Hello developers!", MODULE_NAME)
		logger.warning("Skipping load packages...", MODULE_NAME)
	pass
