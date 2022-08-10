# ----------------------------------------
# res://core/singletons/utils.gd
# ----------------------------------------
# Utilities for easier programming.

extends Node

# ----------------------------------------
# File Operations
# ----------------------------------------

func file_exists(path) -> bool:
	return File.file_exists(path)

# ----------------------------------------
# Scene Operations
# ----------------------------------------

## Reparent a node under a new parent.
## Optionally updates the transform to mantain the current
## position, scale and rotation values.
func reparent_node(node: Node2D, new_parent, update_transform = false) -> void:
	var previous_xform = node.global_transform
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	if update_transform:
		node.global_transform = previous_xform

# ----------------------------------------
# PCK Package Manager
# ----------------------------------------

## Load *.pck file from a given path.
## Reference: 
