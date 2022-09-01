# ----------------------------------------
# loader.gd
# ----------------------------------------
# Multi threaded resource loader.
class_name ThreadLoader
const MODULE_NAME = "ThreadLoader"

var _queue : Dictionary = {}
var _logger : LogWriter = null
var _timer : Timer = null


# Public ---------------------------------
# Set Logger for log handling.
func set_logger(logger: LogWriter) -> void:
	_logger = logger
	pass


# Set Timer for update load status periodically.
func set_timer(timer: Timer) -> void:
	_timer = timer
	timer.timeout.connect(_on_timer_timeout)
	pass


# Get current load queue.
func get_queue() -> Dictionary:
	return _queue


# Request a reource load.
# Return a LoadSignal<completed, updated>.
# Example: loader.request("res://main.tscn", true).updated.connect(_on_loader_updated)
func request(path: String, use_sub_threads: bool = true) -> LoadSignal:
	if _queue.has(path):
		if _logger != null:
			_logger.info("Resource already in queue: %s." % [path], MODULE_NAME)
		return _queue[path]
	else:
		var load_signal = LoadSignal.new()
		_queue[path] = load_signal
		if _timer != null:
			if _logger != null:
				_logger.info("Now loading: %s" % [path], MODULE_NAME)
			ResourceLoader.load_threaded_request(path, "", use_sub_threads)
			if _timer.is_stopped():
				_timer.start()
			return load_signal
		else:
			if _logger != null:
				_logger.fatal("Timer is null, all loadsignals will be broken!", MODULE_NAME)
			return null


# Private --------------------------------
# Timer function for checking loading status.
func _on_timer_timeout() -> void:
	if _queue.is_empty() == false:
		var remove = []
		for path in _queue:
			var array = []
			var status = ResourceLoader.load_threaded_get_status(path, array)
			var progress = float(array[0] * 100.0)
			_queue[path].updated.emit(path, progress)
			if status == ResourceLoader.THREAD_LOAD_LOADED:
				var resource = ResourceLoader.load_threaded_get(path)
				_queue[path].completed.emit(path, resource)
				if _logger != null:
					_logger.info("Loaded: %s." % [path], MODULE_NAME)
				remove.append(path)
			elif status != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if _logger != null:
					_logger.error("Failed when loading resource: %s!" % [path], MODULE_NAME)
				_queue[path].completed.emit(path, null)
				remove.append(path)
		for path in remove:
			if _logger != null:
				_logger.info("Remove %s from loading queue." % [path], MODULE_NAME)
			_queue.erase(path)
	else:
		if _logger != null:
			_logger.info("Timer stopped.", MODULE_NAME)
		_timer.stop()
	pass


# Class ----------------------------------
# Resource LoadSignal.
class LoadSignal:
	signal completed(path: String, resource: Resource)
	signal updated(path: String, progress: float)
