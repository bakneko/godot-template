# ----------------------------------------
# pckmgr.gd
# ----------------------------------------
# Game Data packages manager.
class_name PackageManager
var MODULE_NAME = "PackageManager"

var _search_path : Array = []
var _packages_list : Array = []


# Public ---------------------------------
# Set Search Path and Scan all Packages
func set_path(path : Array) -> void:
	clear()
	_search_path = path
	_packages_list = _get_all_packages()
	Utility.logger.info("Set _search_path to: %s" % [_search_path], MODULE_NAME)
	pass


# Load all Packages in _packages_path
func load_packages() -> void: 
	# TODO: Handle if empty.
	var _total = _packages_list.size()
	var _index = 0
	var _progress = 0.0
	Utility.logger.info("Total package count: %s." % [_total], MODULE_NAME)
	for package in _packages_list:
		_index += 1
		_progress = float(_index) / float(_total) * 100.0
		Utility.logger.info("%s%% Loading: %s..." % [_progress, package], MODULE_NAME)
		if ProjectSettings.load_resource_pack(package):
			pass
	pass


# Clear All Variables
func clear() -> void:
	_search_path = []
	_packages_list = []
	Utility.logger.info("Data cleared.", MODULE_NAME)
	pass


# Private --------------------------------
# Get packages in given path
func _get_packages(path : String) -> Array:
	var regex = RegEx.new()
	regex.compile(".pck$")
	return Utility.get_files_recursive(path, regex)


# Get all packages
func _get_all_packages() -> Array:
	var packs = []
	for path in _search_path:
		packs.append_array(_get_packages(path))
	return packs
