# ----------------------------------------
# utils.gd
# ----------------------------------------
# Quality of life functions.
extends Node

@onready var Logger = preload("res://core/classes/logger.gd").new()
@onready var Pckmgr = preload("res://core/classes/pckmgr.gd").new()


# File Operations ------------------------
# Get files in folder and subfolders. Regex Match is supported.
func get_files_recursive(path : String, regex : RegEx = null):
	var files = []
	var dir := Directory.new()
	# TODO: Use Logger (preload in Utils)
	if dir.open(path) != OK:
		print("Warning: could not open directory: ", path)
		return []
	if dir.list_dir_begin() != OK:
		print("Warning: could not list contents of: ", path)
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
