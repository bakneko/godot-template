# ----------------------------------------
# splash.gd
# ----------------------------------------
# Logic code of 'splash.tscn'
extends Control
const MODULE_NAME = "Splash"


# Entrypoint -----------------------------
func _ready():
	Utils.logger.ready(MODULE_NAME)
	$AnimationPlayer.play("splash")
	pass


# Animation functions --------------------
# Change scene
func change_scene():
	Game.change_scene(Data.MAIN_SCENE_PATH, true, Data.TRANSITION_IMAGE_PATH)
	pass
