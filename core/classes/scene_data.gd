extends Reference
class_name SceneData

var path: String = ""
var params = null

func to_string():
	return "[SceneData] " + path + " with parameters: " + str(params)
