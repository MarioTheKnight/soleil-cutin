@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("SoleilCutins", "res://addons/soleil_cutin/autoloads/soleil_cutin.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("SoleilCutins")
