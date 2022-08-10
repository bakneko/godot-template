# ----------------------------------------
# res://core/classes/pck.gd
# ----------------------------------------
# Godot data pack manager.
extends Node

var LoadingProgress = 0
var CurrentPackIndex = 0
var TotalPcks = 0

func load_pcks(): 
	# loading pack in pack list and update progress
	var pack_list = get_all_packs()
	TotalPacks = pack_list.size()
	for pack in pack_list:
		if ProjectSettings.load_resource_pack(pack):
			print(pack + " loaded successfully!")
			CurrentPackIndex += 1
			LoadingProgress = CurrentPackIndex / TotalPacks * 100
	pass

func get_all_packs(): # get packs list in all dirs
	var pack_list = []
	var directory_list = get_directory_list()
	for directory in directory_list:
		var packs = get_packs_in_directory(directory)
		pack_list.append_array(packs)
	return pack_list

func get_directory_list(content_path): # get dir list    success ret list     fail ret -1    non ret 0
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

func get_packs_in_directory(path):
	# get all packs in directory and return pack list
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
