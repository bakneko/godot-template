# ----------------------------------------
# logger.gd
# ----------------------------------------
# Game Debug information logger.
class_name LogWriter
const MODULE_NAME = "LogWriter"

var _level_dict : Dictionary = {
	0 : "INFO",
	1 : "WARNING",
	2 : "ERROR",
	3 : "FATAL",
}


# Public ---------------------------------
# Log INFO 0.
func info(text: String, module: String = "NONE") -> void:
	_write(0, module, text)
	pass


# Log WARNING 1.
func warning(text: String, module: String = "NONE") -> void:
	_write(1, module, text)
	pass


# Log ERROR 2.
func error(text: String, module: String = "NONE") -> void:
	_write(2, module, text)
	pass


# Log FATAL 3.
func fatal(text: String, module: String = "NONE") -> void:
	_write(3, module, text)
	pass


# Log Ready (info)
func ready(module: String) -> void:
	_write(0, module, "%s is now ready!" % [module])


# Private --------------------------------
# Get Log line prefix.
func _get_prefix(level: int, module: String = "NONE") -> String:
	var datetime_string = Time.get_datetime_string_from_system(false, false)
	return "[%s] [%s] %s: " % [datetime_string, _level_dict[level], module]


# Build string and write
func _write(level: int, module: String, text: String) -> void:
	var content = "%s%s" % [_get_prefix(level, module), text]
	if level == 0:
		print(content)
	elif level == 1:
		print_rich("[color=yellow]%s[/color]" % [content])
	elif level == 2 || level == 3:
		print_rich("[color=red]%s[/color]" % [content])
		print_stack()
	pass
