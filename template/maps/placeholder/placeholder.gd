# ----------------------------------------
# placeholder.gd
# ----------------------------------------
# Logic code of 'placeholder.tscn'
extends Node2D
const MODULE_NAME = "PlaceHolder"


# Entrypoint -----------------------------
func _ready():
	$Control.size = Game.viewport_size
	Utils.logger.ready(MODULE_NAME)
	pass
