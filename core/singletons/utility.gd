# ----------------------------------------
# utility.gd
# ----------------------------------------
# Functions for tool use.
extends Node
var MODULE_NAME = "Utility"

@onready var logger = load("res://core/classes/logger.gd").new()
@onready var pckmgr = load("res://core/classes/pckmgr.gd").new()


# Entrypoint -----------------------------
func _ready():
	# Init LogWriter
	
	# Init PackageManager and Load .pck files
	var search_path = [
		"res://sandbox/build/contents",
		"res://sandbox/build/patches",
	]
	pckmgr.set_logger(logger)
	pckmgr.set_path(search_path)
	pass


# File Operations ------------------------
# Get files in folder and subfolders. Regex Match is supported.
func get_files_recursive(path : String, regex : RegEx = null) -> Array:
	var files = []
	var dir := Directory.new()
	if dir.open(path) != OK:
		logger.error("Could not open directory: %s" % path, MODULE_NAME)
		return []
	if dir.list_dir_begin() != OK:
		logger.error("Could not list contents of: %s" % path, MODULE_NAME)
		return []
	var file := dir.get_next()
	while file != "":
		if dir.current_is_dir():
			files += get_files_recursive(dir.get_current_dir().plus_file(file), regex)
		else:
			var file_path = dir.get_current_dir().plus_file(file)
			if regex != null:
				if regex.search(file_path):
					files.append(file_path)
			else:
				files.append(file_path)
		file = dir.get_next()
	return files
