# ----------------------------------------
# splash.gd
# ----------------------------------------
# Logic code of 'splash.tscn'
extends Control
const MODULE_NAME = "Splash"

var scene_signal: Utils.SceneSignal


# Entrypoint -----------------------------
func _ready():
	$AnimationPlayer.play("Splash")
	pass


# Change scene
func change_scene():
	var path = Data.MAIN_SCENE
	pass
