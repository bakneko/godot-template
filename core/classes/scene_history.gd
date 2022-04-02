extends Reference

const MAX_HISTORY_LENGTH = 10
var _history = []


func add(scene_path: String, params = null) -> void:
	var data = SceneData.new()
	data.path = scene_path
	data.params = params
	_history.push_front(data)
	while(_history.size() > MAX_HISTORY_LENGTH):
		_history.pop_back()
	pass


func get_last_loaded_scene_data() -> SceneData:
	if _history.size() == 0:
		return null
	return _history[0]
