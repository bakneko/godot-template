# ----------------------------------------
# splash.gd
# ----------------------------------------
# Logic code of 'splash.tscn'
extends Control
const MODULE_NAME = "Splash"

var scene_signal : Utils.SceneSignal = Utils.SceneSignal.new()


# Entrypoint -----------------------------
func _ready():
	Utils.logger.ready(MODULE_NAME)
	$AnimationPlayer.play("splash")
	pass


# Change scene
func change_scene():
	scene_signal.change_scene_requested.emit(Data.MAIN_SCENE_PATH)
	pass
