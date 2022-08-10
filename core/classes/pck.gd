# ----------------------------------------
# res://core/classes/pck.gd
# ----------------------------------------
# Godot data pack manager.
class_name PackageManager


var _progress = 0.0
var _index = 0
var _total = 0
var _packages_path = ""
var _packages_list = []
var _logger = null
var _predefined_paths = {
	"contents": OS.get_executable_path().get_base_dir().plus_file("contents"),
	"patches": OS.get_executable_path().get_base_dir().plus_file("patches"),
	"mods": OS.get_executable_path().get_base_dir().plus_file("mods"),
}


# Initialization.
func _init(packages_path = null, logger = null):
	if packages_path is not null:
		_packages_path = packages_path
	if logger is not null:
		_logger = logger
	_packages_list = _get_all_packages()
	pass


# Load all Packages in _packages_path
func load_packages(): 
	# loading packages in list and write log if defined.
	_packages_list = _get_all_packages()
	_total = _packages_list.size()
	for package in _packages_list:
		if ProjectSettings.load_resource_pack(package):
			_index += 1
			@warning_ignore(integer_division)
			_progress = _index / _total * 100
			if _logger is not null:
				# TODO: Write log here
				pass
	pass


# Get all Packages in _packages_path
func _get_all_packages():
	var pack_list = []
	var dir_list = _get_directory_list()
	for directory in dir_list:
		var packs = _get_package_list(directory)
		pack_list.append_array(packs)
	return pack_list

# get dir list    success ret list     fail ret -1    non ret 0
func _get_directory_list(): 
	var directory_list = []
	var contents_directory = Directory.new()
	if contents_directory.open(content_path) == OK:
		contents_directory.list_dir_begin(true, true)
	else:
		return -1;
	
	while true:
		var name = contents_directory.get_current_dir().plus_file(contents_directory.get_next())
		if name == contents_directory.get_current_dir().plus_file(""):
			break
			
		var directory = Directory.new()
		if directory.dir_exists(name):
			directory_list.append(name)
	
	contents_directory.list_dir_end()
	
	return directory_list if directory_list.size() != 0 else 0


func _get_package_list(path):
	# get all packs in directory, and return pack list
	var pack_list = []
	var directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin(true, true)
	while true:
		var name = directory.get_current_dir().plus_file(directory.get_next())
		if name == directory.get_current_dir().plus_file(""):
			break
		if name.ends_with(".pck"):
			pack_list.append(name)
	return pack_list
