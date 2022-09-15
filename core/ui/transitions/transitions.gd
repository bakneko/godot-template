# ----------------------------------------
# transitions.gd
# ----------------------------------------
# Logic code of transition scenes.
extends Control
const MODULE_NAME = "Transitions"

var transignal = Game.Transignal.new()

var _target_path : String = ""
var _target_resource : Resource = null

# Entrypoint -----------------------------
func _ready() -> void:
	Utils.logger.ready(MODULE_NAME)
	%AnimationPlayer.play("intro")
	pass


# Signal handler -------------------------
# Call down from Game.
func _on_loader_updated(_path: String, progress: float) -> void:
	# Update progress bar.
	if get_node("%ProgressBar") != null:
		%ProgressBar.value = progress
	pass


# Call down from Game.
func _on_loader_completed(path: String, resource: Resource) -> void:
	_target_path = path
	_target_resource = resource
	%AnimationPlayer.queue("outro")
	pass


# Animation functions --------------------
# Signal to Game.
func remove_old_scene() -> void:
	transignal.remove_old_scene_requested.emit()
	pass


# Signal to Game.
func set_new_scene() -> void:
	transignal.set_new_scene_requested.emit(_target_path, _target_resource)
	move_to_front()
	pass
