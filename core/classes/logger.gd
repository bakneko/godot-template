# ----------------------------------------
# logger.gd
# ----------------------------------------
# Game Debug information logger.
class_name LogWriter
var MODULE_NAME = "LogWriter"

var path
var display


func _get_prefix(level, module):
	var prefix = ""
	var time_string = _get_local_time()
	
	return prefix


func _get_local_time():
	
	pass

func info(text : String, module : String):
	print("[%s] %s", module, text)
	pass


func clear():
	path = ""
	display = true
	pass
