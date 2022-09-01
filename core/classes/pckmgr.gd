# ----------------------------------------
# pckmgr.gd
# ----------------------------------------
# Game Data packages manager.
class_name PackageManager
const MODULE_NAME = "PackageManager"

var _search_path : Array = []
var _packages_list : Array = []
var _logger : LogWriter = null


# Public ---------------------------------
# Set Search Path and Scan all Packages
func set_path(path: Array) -> void:
	clear()
	_search_path = path
	_packages_list = _get_all_packages()
	if _logger != null:
		_logger.info("Set \"_search_path\" to: %s." % [_search_path], MODULE_NAME)
	pass


# Set Logger for log handling.
func set_logger(logger: LogWriter) -> void:
	_logger = logger
	pass


# Load all Packages in _packages_path
func load_packages() -> void: 
	# TODO: Handle if empty.
	var total = _packages_list.size()
	var index = 0
	var progress = 0.0
	if _logger != null:
		_logger.info("Total packages: %s." % [total], MODULE_NAME)
	for package in _packages_list:
		index += 1
		progress = float(index) / float(total) * 100.0
		if _logger != null:
			_logger.info("%s%% Loading: %s..." % [progress, package], MODULE_NAME)
		if !ProjectSettings.load_resource_pack(package):
			if _logger != null:
				_logger.error("Failed when loading package: %s!" % [package], MODULE_NAME)
			pass
	pass


# Print all Packages
func print_packages() -> void:
	if _logger != null:
		var total = _packages_list.size()
		_logger.info("Total packages: %s." % [total], MODULE_NAME)
		for package in _packages_list:
			_logger.info("%s" % [package], MODULE_NAME)
	pass


# Clear All Variables
func clear() -> void:
	_search_path = []
	_packages_list = []
	if _logger != null:
		_logger.info("Data cleared.", MODULE_NAME)
	pass


# Private --------------------------------
# Get packages in given path
func _get_packages(path: String) -> Array:
	var regex = RegEx.new()
	regex.compile(".pck$")
	return Utils.get_files_recursive(path, regex)


# Get all packages
func _get_all_packages() -> Array:
	var packs = []
	for path in _search_path:
		packs.append_array(_get_packages(path))
	return packs
