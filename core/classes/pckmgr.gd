# ----------------------------------------
# pckmgr.gd
# ----------------------------------------
# Data packages manager.
class_name PackageManager

var _progress
var _index
var _total
var _search_path
var _packages_list


# Public ---------------------------------
# Add Search Path and Scan all Packages
func set_path(path):
	# 改成Add Search Path
	_clear()
	if path != null:
		_search_path = path
	_packages_list = _get_all_packages()
	pass


# Load all Packages in _packages_path
func load_packages(): 
	# Handle if Null
	# loading packages in list.
	_total = _packages_list.size()
	for package in _packages_list:
		if ProjectSettings.load_resource_pack(package):
			_index += 1
			@warning_ignore(integer_division)
			_progress = _index / _total * 100
			# TODO: Write log here
			pass
	pass


# Private --------------------------------
# Clear All Variables
func _clear():
	_progress = 0.0
	_index = 0
	_total = 0
	_search_path = ""
	_packages_list = []
	pass


# Get all Packages in _packages_path
func _get_all_packages():
	var regex = RegEx.new()
	regex.compile(".pck$")
	return Utility.get_files_recursive(_search_path, regex)
